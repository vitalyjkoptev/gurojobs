<?php

namespace App\Http\Controllers\Candidate;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\JobApplication;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ApplicationsController extends Controller
{
    /**
     * GET /api/v1/candidate/applications
     * Список откликов кандидата с заметками и инфой о рекрутере.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $applications = JobApplication::where('candidate_id', $user->id)
            ->with([
                'job:id,title,slug,company_id,status,created_at',
                'job.company:id,user_id,name,slug,logo',
                'job.company.owner:id,name,last_seen_at,created_at',
            ])
            ->orderByDesc('created_at')
            ->paginate(20);

        // Добавляем данные о рекрутере к каждому отклику
        $applications->getCollection()->transform(function ($app) {
            $recruiter = $app->job?->company?->owner;
            $app->recruiter_info = $recruiter ? [
                'id' => $recruiter->id,
                'name' => $recruiter->name,
                'last_seen_at' => $recruiter->last_seen_at?->toISOString(),
                'member_since' => $recruiter->created_at->toISOString(),
                'years_on_platform' => $recruiter->created_at->diffInYears(now()),
            ] : null;

            return $app;
        });

        return response()->json([
            'success' => true,
            'data' => $applications,
        ]);
    }

    /**
     * POST /api/v1/candidate/apply/{jobId}
     * Откликнуться на вакансию.
     */
    public function apply(Request $request, int $jobId): JsonResponse
    {
        $user = $request->user();
        $job = Job::findOrFail($jobId);

        // Проверяем дубликат
        $existing = JobApplication::where('job_id', $jobId)
            ->where('candidate_id', $user->id)
            ->first();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'You already applied to this job.',
            ], 422);
        }

        $request->validate([
            'cover_letter' => 'sometimes|string|max:3000',
            'resume' => 'sometimes|file|mimes:pdf|max:5120',
        ]);

        $resumePath = null;
        if ($request->hasFile('resume')) {
            $resumePath = $request->file('resume')->store('application_resumes', 'public');
        }

        $application = JobApplication::create([
            'job_id' => $jobId,
            'candidate_id' => $user->id,
            'cover_letter' => $request->input('cover_letter'),
            'resume_path' => $resumePath,
            'status' => 'pending',
        ]);

        // Обновляем счётчик
        $job->incrementApplications();

        return response()->json([
            'success' => true,
            'message' => 'Application submitted.',
            'data' => $application,
        ], 201);
    }

    /**
     * PUT /api/v1/candidate/applications/{id}/notes
     * Добавить/обновить заметку к отклику.
     */
    public function updateNotes(Request $request, int $id): JsonResponse
    {
        $user = $request->user();

        $application = JobApplication::where('id', $id)
            ->where('candidate_id', $user->id)
            ->firstOrFail();

        $request->validate([
            'candidate_notes' => 'required|string|max:5000',
        ]);

        $application->update([
            'candidate_notes' => $request->input('candidate_notes'),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Notes saved.',
            'data' => [
                'id' => $application->id,
                'candidate_notes' => $application->candidate_notes,
            ],
        ]);
    }

    /**
     * DELETE /api/v1/candidate/applications/{id}/notes
     * Удалить заметку.
     */
    public function deleteNotes(Request $request, int $id): JsonResponse
    {
        $user = $request->user();

        $application = JobApplication::where('id', $id)
            ->where('candidate_id', $user->id)
            ->firstOrFail();

        $application->update(['candidate_notes' => null]);

        return response()->json([
            'success' => true,
            'message' => 'Notes deleted.',
        ]);
    }
}
