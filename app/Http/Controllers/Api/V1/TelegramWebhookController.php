<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Telegram\TelegramService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class TelegramWebhookController extends Controller
{
    protected TelegramService $telegram;

    public function __construct(TelegramService $telegram)
    {
        $this->telegram = $telegram;
    }

    public function handle(Request $request): JsonResponse
    {
        $update = $request->all();

        Log::info('Telegram webhook received', ['update_id' => $update['update_id'] ?? null]);

        // Handle callback queries (button presses)
        if (isset($update['callback_query'])) {
            $this->handleCallback($update['callback_query']);
            return response()->json(['ok' => true]);
        }

        // Handle messages
        if (isset($update['message'])) {
            $this->handleMessage($update['message']);
        }

        return response()->json(['ok' => true]);
    }

    protected function handleMessage(array $message): void
    {
        $chatId = $message['chat']['id'];
        $text = $message['text'] ?? '';
        $from = $message['from'] ?? [];

        // Command handlers
        if (str_starts_with($text, '/')) {
            $this->handleCommand($chatId, $text, $from);
            return;
        }

        // Default response
        $this->telegram->sendMessage(
            $chatId,
            "👋 Welcome to <b>GURO JOBS</b> bot!\n\nUse /help to see available commands.",
        );
    }

    protected function handleCommand(int|string $chatId, string $text, array $from): void
    {
        $command = strtolower(trim(explode(' ', $text)[0]));

        switch ($command) {
            case '/start':
                $name = $from['first_name'] ?? 'there';
                $this->telegram->sendMessageWithButtons($chatId,
                    "🎰 Welcome to <b>GURO JOBS</b>, {$name}!\n\n"
                    . "I'm your iGaming career assistant.\n\n"
                    . "🔹 Browse latest jobs\n"
                    . "🔹 Get job alerts\n"
                    . "🔹 Connect your account\n\n"
                    . "Use the buttons below or /help for commands.",
                    [
                        [['text' => '🔍 Browse Jobs', 'url' => 'https://gurojobs.com/jobs']],
                        [['text' => '📱 Download App', 'url' => 'https://gurojobs.com/app']],
                        [
                            ['text' => '💼 For Employers', 'url' => 'https://gurojobs.com/for-employers'],
                            ['text' => '👥 Community', 'url' => 'https://t.me/GuroJobs'],
                        ],
                    ],
                );
                break;

            case '/help':
                $this->telegram->sendMessage($chatId,
                    "📖 <b>Available Commands:</b>\n\n"
                    . "/start — Welcome message\n"
                    . "/jobs — Latest job listings\n"
                    . "/connect — Link your GURO JOBS account\n"
                    . "/help — Show this help\n\n"
                    . "🌐 Website: gurojobs.com",
                );
                break;

            case '/jobs':
                $this->telegram->sendMessageWithButtons($chatId,
                    "🎰 <b>Latest iGaming Jobs</b>\n\n"
                    . "Browse our latest job openings on the website:",
                    [
                        [['text' => '🔍 View All Jobs', 'url' => 'https://gurojobs.com/jobs']],
                        [['text' => '🎲 Casino', 'url' => 'https://gurojobs.com/jobs?category=casino']],
                        [
                            ['text' => '⚽ Betting', 'url' => 'https://gurojobs.com/jobs?category=betting'],
                            ['text' => '🎮 eSports', 'url' => 'https://gurojobs.com/jobs?category=esports'],
                        ],
                    ],
                );
                break;

            case '/connect':
                $username = $from['username'] ?? null;
                if ($username) {
                    $user = User::where('telegram_username', '@' . $username)
                        ->orWhere('telegram_username', $username)
                        ->first();

                    if ($user) {
                        $user->update(['telegram_id' => (string) $from['id']]);
                        $this->telegram->sendMessage($chatId,
                            "✅ Account linked!\n\n"
                            . "Welcome, <b>{$user->name}</b>!\n"
                            . "You'll now receive job notifications here.",
                        );
                    } else {
                        $this->telegram->sendMessageWithButtons($chatId,
                            "🔗 To connect your account:\n\n"
                            . "1. Register on gurojobs.com\n"
                            . "2. Add <code>@{$username}</code> as your Telegram in profile\n"
                            . "3. Run /connect again",
                            [
                                [['text' => '📝 Register', 'url' => 'https://gurojobs.com/register']],
                            ],
                        );
                    }
                } else {
                    $this->telegram->sendMessage($chatId,
                        "⚠️ Please set a Telegram username first, then try /connect again.",
                    );
                }
                break;

            default:
                $this->telegram->sendMessage($chatId,
                    "❓ Unknown command. Use /help to see available commands.",
                );
        }
    }

    protected function handleCallback(array $callback): void
    {
        $this->telegram->answerCallbackQuery($callback['id']);

        $chatId = $callback['message']['chat']['id'] ?? null;
        $data = $callback['data'] ?? '';

        if (!$chatId) return;

        if (str_starts_with($data, 'job_')) {
            $jobId = substr($data, 4);
            $this->telegram->sendMessageWithButtons($chatId,
                "📋 View full job details on our website:",
                [
                    [['text' => '📋 View Job', 'url' => "https://gurojobs.com/jobs/{$jobId}"]],
                ],
            );
        }
    }
}
