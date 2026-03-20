<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Services\Jarvis\JarvisService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JarvisController extends Controller
{
    public function __construct(protected JarvisService $jarvisService)
    {
    }

    /**
     * Process a voice or text command.
     */
    public function command(Request $request): JsonResponse
    {
        $request->validate([
            'command' => 'required|string|max:1000',
            'type' => 'sometimes|in:voice,text',
        ]);

        $user = $request->user();

        // Only admin and employer can use Jarvis
        $role = $user->role instanceof UserRole ? $user->role->value : $user->role;
        if (!in_array($role, ['admin', 'employer'])) {
            return response()->json([
                'success' => false,
                'response' => 'Jarvis is available for admin and employer accounts only.',
            ], 403);
        }

        $result = $this->jarvisService->processCommand(
            $request->input('command'),
            $user,
            $request->input('type', 'text')
        );

        return response()->json($result);
    }

    /**
     * Get command history.
     */
    public function history(Request $request): JsonResponse
    {
        $user = $request->user();
        $limit = $request->input('limit', 50);

        $history = $this->jarvisService->getHistory($user, $limit);

        return response()->json([
            'success' => true,
            'data' => $history,
        ]);
    }
}
