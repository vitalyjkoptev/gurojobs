<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\User;
use App\Services\Paywall\PaywallService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function __construct(
        private PaywallService $paywall
    ) {}

    /**
     * GET /api/v1/messages/conversations
     * Список диалогов (уникальные собеседники).
     */
    public function conversations(Request $request): JsonResponse
    {
        $user = $request->user();

        $uid = (int) $user->id;

        $conversations = Message::where(function ($q) use ($uid) {
            $q->where('sender_id', $uid)->orWhere('receiver_id', $uid);
        })
            ->where('is_blocked', false)
            ->selectRaw("
                CASE WHEN sender_id = {$uid} THEN receiver_id ELSE sender_id END as partner_id,
                MAX(created_at) as last_message_at,
                COUNT(CASE WHEN receiver_id = {$uid} AND read_at IS NULL THEN 1 END) as unread_count
            ")
            ->groupByRaw("CASE WHEN sender_id = {$uid} THEN receiver_id ELSE sender_id END")
            ->orderByDesc('last_message_at')
            ->get();

        // Подгружаем данные собеседников
        $partnerIds = $conversations->pluck('partner_id');
        $partners = User::whereIn('id', $partnerIds)
            ->select('id', 'name', 'avatar', 'role', 'last_seen_at')
            ->get()
            ->keyBy('id');

        $result = $conversations->map(function ($conv) use ($partners) {
            $partner = $partners->get($conv->partner_id);
            return [
                'partner_id' => $conv->partner_id,
                'partner_name' => $partner?->name,
                'partner_avatar' => $partner?->avatar,
                'partner_role' => $partner?->role?->value ?? $partner?->role,
                'partner_last_seen' => $partner?->last_seen_at?->toISOString(),
                'last_message_at' => $conv->last_message_at,
                'unread_count' => $conv->unread_count,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $result,
            'paywall' => $this->paywall->getPaywallStatus($user),
        ]);
    }

    /**
     * GET /api/v1/messages/{userId}
     * Сообщения в конкретном диалоге.
     */
    public function thread(Request $request, int $userId): JsonResponse
    {
        $user = $request->user();

        $messages = Message::where(function ($q) use ($user, $userId) {
            $q->where(function ($q2) use ($user, $userId) {
                $q2->where('sender_id', $user->id)->where('receiver_id', $userId);
            })->orWhere(function ($q2) use ($user, $userId) {
                $q2->where('sender_id', $userId)->where('receiver_id', $user->id);
            });
        })
            ->orderByDesc('created_at')
            ->paginate(50);

        // Помечаем входящие как прочитанные
        Message::where('sender_id', $userId)
            ->where('receiver_id', $user->id)
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        // Инфо о собеседнике
        $partner = User::select('id', 'name', 'avatar', 'role', 'last_seen_at', 'created_at')
            ->find($userId);

        return response()->json([
            'success' => true,
            'data' => $messages,
            'partner' => $partner ? [
                'id' => $partner->id,
                'name' => $partner->name,
                'avatar' => $partner->avatar,
                'role' => $partner->role?->value ?? $partner->role,
                'last_seen_at' => $partner->last_seen_at?->toISOString(),
                'member_since' => $partner->created_at->toISOString(),
            ] : null,
        ]);
    }

    /**
     * POST /api/v1/messages
     * Отправить сообщение.
     */
    public function send(Request $request): JsonResponse
    {
        $user = $request->user();

        // Пейволл: проверяем право на отправку
        if (!$this->paywall->canSendMessages($user)) {
            return response()->json([
                'success' => false,
                'message' => 'Upgrade your plan to send messages.',
                'paywall' => $this->paywall->getPaywallStatus($user),
            ], 403);
        }

        $request->validate([
            'receiver_id' => 'required|integer|exists:users,id',
            'body' => 'required|string|max:5000',
            'job_application_id' => 'sometimes|integer|exists:job_applications,id',
        ]);

        $receiverId = $request->input('receiver_id');
        $body = $request->input('body');

        // Не писать самому себе
        if ($receiverId == $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot message yourself.',
            ], 422);
        }

        // Проверяем контент на запрещённое (для FREE плана)
        $blockReason = $this->paywall->checkMessageContent($user, $body);
        if ($blockReason) {
            $messages = [
                'contains_link' => 'Links (Zoom, Google Meet, etc.) are only available on paid plans.',
                'contains_contact' => 'Sharing contact information (email, phone, Telegram) requires a paid plan.',
            ];

            return response()->json([
                'success' => false,
                'message' => $messages[$blockReason] ?? 'Message blocked.',
                'block_reason' => $blockReason,
                'paywall' => $this->paywall->getPaywallStatus($user),
            ], 403);
        }

        $message = Message::create([
            'sender_id' => $user->id,
            'receiver_id' => $receiverId,
            'job_application_id' => $request->input('job_application_id'),
            'body' => $body,
            'is_blocked' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Message sent.',
            'data' => $message,
        ], 201);
    }
}
