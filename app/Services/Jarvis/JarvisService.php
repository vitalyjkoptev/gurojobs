<?php

namespace App\Services\Jarvis;

use App\Models\JarvisLog;
use App\Models\User;
use Illuminate\Support\Facades\Http;

class JarvisService
{
    protected IntentParser $intentParser;
    protected CommandExecutor $commandExecutor;

    public function __construct(IntentParser $intentParser, CommandExecutor $commandExecutor)
    {
        $this->intentParser = $intentParser;
        $this->commandExecutor = $commandExecutor;
    }

    public function processCommand(string $commandText, User $user, string $type = 'text'): array
    {
        $intent = $this->intentParser->parse($commandText);

        $result = $this->commandExecutor->execute($intent, $user);

        $log = JarvisLog::create([
            'user_id' => $user->id,
            'command_text' => $commandText,
            'command_type' => $type,
            'intent' => $intent['intent'],
            'response_text' => $result['response'],
            'action_taken' => $result['action'] ?? null,
            'success' => $result['success'],
        ]);

        return [
            'response' => $result['response'],
            'data' => $result['data'] ?? null,
            'action' => $result['action'] ?? null,
            'success' => $result['success'],
            'log_id' => $log->id,
        ];
    }

    public function getHistory(User $user, int $limit = 50): array
    {
        return JarvisLog::where('user_id', $user->id)
            ->latest()
            ->limit($limit)
            ->get()
            ->toArray();
    }
}
