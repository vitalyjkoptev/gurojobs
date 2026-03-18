<?php

namespace App\Services\Jarvis;

use Illuminate\Support\Facades\Http;

class IntentParser
{
    protected array $intents = [
        'stats.today' => ['stats today', 'statistics', 'how many today', 'today\'s numbers', 'сколько сегодня', 'статистика'],
        'stats.period' => ['stats for', 'last week', 'last month', 'monthly report', 'weekly', 'отчет за'],
        'jobs.list' => ['show jobs', 'list jobs', 'active jobs', 'vacancies', 'вакансии', 'список'],
        'jobs.create' => ['post job', 'create job', 'new vacancy', 'add job', 'создать вакансию', 'новая'],
        'jobs.update' => ['pause job', 'close job', 'update job', 'edit job', 'изменить', 'закрыть'],
        'users.list' => ['show users', 'list candidates', 'list employers', 'new users', 'пользователи', 'кандидаты'],
        'users.block' => ['block user', 'suspend', 'ban', 'заблокировать'],
        'applications.list' => ['applications', 'new applications', 'pending', 'заявки', 'отклики'],
        'payments.status' => ['revenue', 'payments', 'income', 'money', 'выручка', 'платежи', 'доход'],
        'search' => ['find', 'search', 'look for', 'искать', 'найти'],
        'report.generate' => ['generate report', 'export', 'download report', 'сгенерировать отчет', 'экспорт'],
        'navigation' => ['go to', 'open', 'navigate', 'перейти', 'открыть'],
    ];

    public function parse(string $command): array
    {
        $commandLower = mb_strtolower($command);

        // Try local pattern matching first
        foreach ($this->intents as $intent => $patterns) {
            foreach ($patterns as $pattern) {
                if (str_contains($commandLower, $pattern)) {
                    return [
                        'intent' => $intent,
                        'command' => $command,
                        'params' => $this->extractParams($intent, $command),
                        'confidence' => 'local',
                    ];
                }
            }
        }

        // Fallback to AI parsing if configured
        if (config('gurojobs.jarvis.ai_enabled')) {
            return $this->parseWithAI($command);
        }

        return [
            'intent' => 'unknown',
            'command' => $command,
            'params' => [],
            'confidence' => 'none',
        ];
    }

    protected function extractParams(string $intent, string $command): array
    {
        $params = [];

        // Extract numbers (IDs)
        if (preg_match('/#?(\d+)/', $command, $matches)) {
            $params['id'] = (int) $matches[1];
        }

        // Extract quoted strings
        if (preg_match('/"([^"]+)"/', $command, $matches)) {
            $params['query'] = $matches[1];
        }

        // Extract period
        if (preg_match('/(?:last|this|за)\s+(week|month|year|неделю|месяц|год)/i', $command, $matches)) {
            $periodMap = [
                'week' => 'week', 'неделю' => 'week',
                'month' => 'month', 'месяц' => 'month',
                'year' => 'year', 'год' => 'year',
            ];
            $params['period'] = $periodMap[mb_strtolower($matches[1])] ?? $matches[1];
        }

        // Extract experience level
        foreach (['c-level', 'head', 'senior', 'middle', 'junior'] as $level) {
            if (str_contains(mb_strtolower($command), $level)) {
                $params['experience_level'] = $level;
                break;
            }
        }

        // Extract search query after keywords
        if (str_starts_with($intent, 'search') || str_starts_with($intent, 'jobs.list')) {
            $cleanedCommand = preg_replace('/^(find|search|look for|искать|найти)\s+/i', '', $command);
            $params['query'] = trim($cleanedCommand);
        }

        return $params;
    }

    protected function parseWithAI(string $command): array
    {
        $response = Http::withHeaders([
            'x-api-key' => config('gurojobs.jarvis.api_key'),
            'Content-Type' => 'application/json',
            'anthropic-version' => '2023-06-01',
        ])->post('https://api.anthropic.com/v1/messages', [
            'model' => config('gurojobs.jarvis.model', 'claude-sonnet-4-6'),
            'max_tokens' => 200,
            'system' => 'You are Jarvis, an AI assistant for GURO JOBS iGaming job portal. Parse the user command and return JSON with: intent (one of: stats.today, stats.period, jobs.list, jobs.create, jobs.update, users.list, users.block, applications.list, payments.status, search, report.generate, navigation, unknown), params (relevant extracted parameters). Respond ONLY with valid JSON.',
            'messages' => [
                ['role' => 'user', 'content' => $command],
            ],
        ]);

        if ($response->successful()) {
            $content = $response->json('content.0.text', '{}');
            $parsed = json_decode($content, true) ?? [];

            return [
                'intent' => $parsed['intent'] ?? 'unknown',
                'command' => $command,
                'params' => $parsed['params'] ?? [],
                'confidence' => 'ai',
            ];
        }

        return [
            'intent' => 'unknown',
            'command' => $command,
            'params' => [],
            'confidence' => 'none',
        ];
    }
}
