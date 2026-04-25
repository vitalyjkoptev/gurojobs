<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TelegramAuthTest extends TestCase
{
    use RefreshDatabase;

    private string $botToken = '123456:test-bot-token';

    protected function setUp(): void
    {
        parent::setUp();

        config()->set('gurojobs.telegram.bot_token', $this->botToken);
        config()->set('gurojobs.telegram.bot_username', 'gurojobs_test_bot');
        config()->set('gurojobs.telegram.auth_ttl', 86400);
        config()->set('gurojobs.telegram.auth_redirect', '/dashboard');
    }

    public function test_callback_creates_new_user_with_pending_status(): void
    {
        $payload = $this->signedPayload([
            'id' => 100200300,
            'first_name' => 'Vitaly',
            'last_name' => 'K',
            'username' => 'vkop',
            'auth_date' => time(),
        ]);

        $response = $this->get('/auth/telegram/callback?' . http_build_query($payload));

        $response->assertOk();

        $this->assertDatabaseHas('users', [
            'telegram_id' => '100200300',
            'telegram_username' => '@vkop',
            'status' => 'pending',
            'email' => null,
        ]);

        $user = User::where('telegram_id', '100200300')->first();
        $this->assertNotNull($user);
        $this->assertTrue($user->needsOnboarding());
        $this->assertAuthenticatedAs($user);
    }

    public function test_callback_logs_in_existing_user_without_duplicating(): void
    {
        $existing = User::factory()->create([
            'telegram_id' => '777',
            'email' => 'existing@example.com',
            'status' => 'active',
            'onboarded_at' => now(),
        ]);

        $payload = $this->signedPayload([
            'id' => 777,
            'first_name' => 'Existing',
            'auth_date' => time(),
        ]);

        $this->get('/auth/telegram/callback?' . http_build_query($payload))->assertOk();

        $this->assertSame(1, User::where('telegram_id', '777')->count());
        $this->assertAuthenticatedAs($existing->fresh());
    }

    public function test_callback_rejects_bad_signature(): void
    {
        $payload = $this->signedPayload([
            'id' => 1,
            'first_name' => 'X',
            'auth_date' => time(),
        ]);
        $payload['hash'] = str_repeat('0', 64);

        $this->get('/auth/telegram/callback?' . http_build_query($payload))
            ->assertForbidden();

        $this->assertDatabaseMissing('users', ['telegram_id' => '1']);
        $this->assertGuest();
    }

    public function test_callback_rejects_expired_payload(): void
    {
        $payload = $this->signedPayload([
            'id' => 2,
            'first_name' => 'Y',
            'auth_date' => time() - 90000, // > 86400
        ]);

        $this->get('/auth/telegram/callback?' . http_build_query($payload))
            ->assertForbidden();

        $this->assertGuest();
    }

    public function test_api_callback_returns_token_and_redirect(): void
    {
        $payload = $this->signedPayload([
            'id' => 555,
            'first_name' => 'Api',
            'auth_date' => time(),
        ]);

        $response = $this->postJson('/api/v1/auth/telegram/callback', $payload);

        $response->assertOk()
            ->assertJsonStructure(['success', 'token', 'user', 'needs_onboarding', 'redirect'])
            ->assertJson(['success' => true, 'needs_onboarding' => true]);
    }

    public function test_link_endpoint_attaches_telegram_to_existing_user(): void
    {
        $user = User::factory()->create(['telegram_id' => null]);

        $payload = $this->signedPayload([
            'id' => 999,
            'first_name' => 'Linker',
            'username' => 'linker',
            'auth_date' => time(),
        ]);

        $this->actingAs($user)
            ->postJson('/api/v1/auth/telegram/link', $payload)
            ->assertOk()
            ->assertJson(['success' => true]);

        $this->assertSame('999', $user->fresh()->telegram_id);
    }

    public function test_link_endpoint_refuses_already_linked_telegram(): void
    {
        User::factory()->create(['telegram_id' => '111']);
        $other = User::factory()->create(['telegram_id' => null]);

        $payload = $this->signedPayload([
            'id' => 111,
            'first_name' => 'Taken',
            'auth_date' => time(),
        ]);

        $this->actingAs($other)
            ->postJson('/api/v1/auth/telegram/link', $payload)
            ->assertStatus(409);
    }

    private function signedPayload(array $data): array
    {
        $check = collect($data)
            ->map(fn($v, $k) => "$k=$v")
            ->sort()
            ->values()
            ->implode("\n");

        $secret = hash('sha256', $this->botToken, true);
        $data['hash'] = hash_hmac('sha256', $check, $secret);

        return $data;
    }
}
