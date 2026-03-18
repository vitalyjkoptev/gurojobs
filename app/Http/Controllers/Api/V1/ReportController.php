<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\Report;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    /**
     * POST /api/v1/reports
     * Пожаловаться на вакансию или кандидата/пользователя.
     */
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'reportable_type' => 'required|string|in:job,user',
            'reportable_id' => 'required|integer',
            'reason' => 'required|string|in:spam,inappropriate,fake,harassment,scam,other',
            'description' => 'sometimes|string|max:2000',
            'attachments' => 'sometimes|array|max:5',
            'attachments.*' => 'file|mimes:jpg,jpeg,png,mp4,mov,webm|max:10240', // max 10MB each
        ]);

        $user = $request->user();

        // Маппинг type -> model class
        $typeMap = [
            'job' => Job::class,
            'user' => User::class,
        ];

        $modelClass = $typeMap[$request->input('reportable_type')];
        $reportableId = $request->input('reportable_id');

        // Проверяем что объект существует
        if (!$modelClass::find($reportableId)) {
            return response()->json([
                'success' => false,
                'message' => 'Object not found.',
            ], 404);
        }

        // Не жаловаться на себя
        if ($request->input('reportable_type') === 'user' && $reportableId == $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'You cannot report yourself.',
            ], 422);
        }

        // Не дублировать жалобу (та же цель, тот же reporter, статус pending)
        $existing = Report::where('reporter_id', $user->id)
            ->where('reportable_type', $modelClass)
            ->where('reportable_id', $reportableId)
            ->where('status', 'pending')
            ->first();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'You already reported this.',
            ], 422);
        }

        // Загрузка файлов
        $attachmentPaths = [];
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $file) {
                $attachmentPaths[] = $file->store('reports', 'public');
            }
        }

        $report = Report::create([
            'reporter_id' => $user->id,
            'reportable_type' => $modelClass,
            'reportable_id' => $reportableId,
            'reason' => $request->input('reason'),
            'description' => $request->input('description'),
            'attachments' => !empty($attachmentPaths) ? $attachmentPaths : null,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Report submitted. Thank you.',
            'data' => $report,
        ], 201);
    }

    /**
     * GET /api/v1/reports (admin only)
     * Список жалоб.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Report::with('reporter:id,name,email')
            ->orderByDesc('created_at');

        if ($request->has('status')) {
            $query->where('status', $request->input('status'));
        }
        if ($request->has('type')) {
            $typeMap = ['job' => Job::class, 'user' => User::class];
            if (isset($typeMap[$request->input('type')])) {
                $query->where('reportable_type', $typeMap[$request->input('type')]);
            }
        }

        $reports = $query->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $reports,
        ]);
    }

    /**
     * PUT /api/v1/reports/{id} (admin only)
     * Обновить статус жалобы.
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $report = Report::findOrFail($id);

        $request->validate([
            'status' => 'required|string|in:reviewed,resolved,dismissed',
            'admin_notes' => 'sometimes|string|max:2000',
        ]);

        $report->update($request->only(['status', 'admin_notes']));

        return response()->json([
            'success' => true,
            'message' => 'Report updated.',
            'data' => $report,
        ]);
    }
}
