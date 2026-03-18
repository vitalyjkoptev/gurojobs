<?php

namespace App\Services\Telegram;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class TelegramService
{
    protected string $token;
    protected string $apiUrl;

    public function __construct()
    {
        $this->token = config('gurojobs.telegram.bot_token', '');
        $this->apiUrl = "https://api.telegram.org/bot{$this->token}";
    }

    /**
     * Send a text message.
     */
    public function sendMessage(int|string $chatId, string $text, ?string $parseMode = 'HTML', ?array $replyMarkup = null): array
    {
        $payload = [
            'chat_id' => $chatId,
            'text' => $text,
            'parse_mode' => $parseMode,
        ];

        if ($replyMarkup) {
            $payload['reply_markup'] = json_encode($replyMarkup);
        }

        return $this->request('sendMessage', $payload);
    }

    /**
     * Set webhook URL.
     */
    public function setWebhook(string $url): array
    {
        return $this->request('setWebhook', [
            'url' => $url,
            'allowed_updates' => json_encode(['message', 'callback_query']),
        ]);
    }

    /**
     * Remove webhook.
     */
    public function deleteWebhook(): array
    {
        return $this->request('deleteWebhook');
    }

    /**
     * Get webhook info.
     */
    public function getWebhookInfo(): array
    {
        return $this->request('getWebhookInfo');
    }

    /**
     * Get bot info.
     */
    public function getMe(): array
    {
        return $this->request('getMe');
    }

    /**
     * Send inline keyboard.
     */
    public function sendMessageWithButtons(int|string $chatId, string $text, array $buttons): array
    {
        $keyboard = ['inline_keyboard' => $buttons];
        return $this->sendMessage($chatId, $text, 'HTML', $keyboard);
    }

    /**
     * Answer callback query.
     */
    public function answerCallbackQuery(string $callbackQueryId, ?string $text = null): array
    {
        $payload = ['callback_query_id' => $callbackQueryId];
        if ($text) {
            $payload['text'] = $text;
        }
        return $this->request('answerCallbackQuery', $payload);
    }

    /**
     * Post a job to the channel.
     */
    public function postJobToChannel(string $channelId, array $job): array
    {
        $text = $this->formatJobMessage($job);
        $buttons = [];

        if (!empty($job['url'])) {
            $buttons[] = [['text' => '📋 Apply Now', 'url' => $job['url']]];
        }

        $buttons[] = [['text' => '🔍 More Jobs', 'url' => 'https://gurojobs.com/jobs']];

        return $this->sendMessageWithButtons($channelId, $text, $buttons);
    }

    /**
     * Format job as a Telegram message.
     */
    protected function formatJobMessage(array $job): string
    {
        $title = $job['title'] ?? 'Job Opening';
        $company = $job['company'] ?? '';
        $location = $job['location'] ?? '';
        $salary = $job['salary'] ?? '';
        $type = $job['type'] ?? '';
        $level = $job['level'] ?? '';

        $message = "🎰 <b>{$title}</b>\n\n";

        if ($company) $message .= "🏢 {$company}\n";
        if ($location) $message .= "📍 {$location}\n";
        if ($salary) $message .= "💰 {$salary}\n";
        if ($type) $message .= "⏰ {$type}\n";
        if ($level) $message .= "📊 {$level}\n";

        if (!empty($job['description'])) {
            $desc = strip_tags($job['description']);
            $desc = mb_substr($desc, 0, 300);
            $message .= "\n{$desc}...\n";
        }

        $message .= "\n#iGaming #Jobs #GuroJobs";

        return $message;
    }

    /**
     * Make API request.
     */
    protected function request(string $method, array $params = []): array
    {
        try {
            $response = Http::timeout(10)->post("{$this->apiUrl}/{$method}", $params);
            return $response->json() ?? ['ok' => false, 'description' => 'Empty response'];
        } catch (\Exception $e) {
            Log::error("Telegram API error [{$method}]: {$e->getMessage()}");
            return ['ok' => false, 'description' => $e->getMessage()];
        }
    }
}
