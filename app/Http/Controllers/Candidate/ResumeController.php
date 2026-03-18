<?php

namespace App\Http\Controllers\Candidate;

use App\Http\Controllers\Controller;
use App\Services\Resume\ResumeBuilderService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ResumeController extends Controller
{
    public function __construct(
        private ResumeBuilderService $resumeService
    ) {}

    /**
     * GET /api/v1/candidate/resume
     * Получить данные резюме для просмотра/редактирования.
     */
    public function show(Request $request): JsonResponse
    {
        $user = $request->user();
        $data = $this->resumeService->getResumeData($user);
        $profile = $user->candidateProfile;

        return response()->json([
            'success' => true,
            'data' => [
                'resume' => $data,
                'resume_updated_at' => $profile?->resume_updated_at?->toISOString(),
                'has_uploaded_resume' => !empty($profile?->resume_path),
                'uploaded_resume_url' => $profile?->resume_path ? asset('storage/' . $profile->resume_path) : null,
                'available_templates' => ['classic', 'modern', 'minimal'],
            ],
        ]);
    }

    /**
     * PUT /api/v1/candidate/resume
     * Сохранить данные резюме (JSON-билдер).
     */
    public function update(Request $request): JsonResponse
    {
        $request->validate([
            'personal' => 'sometimes|array',
            'personal.full_name' => 'sometimes|string|max:255',
            'personal.email' => 'sometimes|email|max:255',
            'personal.phone' => 'sometimes|string|max:50',
            'personal.location' => 'sometimes|string|max:255',
            'personal.summary' => 'sometimes|string|max:2000',
            'experience' => 'sometimes|array',
            'experience.*.company' => 'required_with:experience|string|max:255',
            'experience.*.position' => 'required_with:experience|string|max:255',
            'experience.*.start_date' => 'sometimes|string|max:20',
            'experience.*.end_date' => 'sometimes|string|max:20',
            'experience.*.current' => 'sometimes|boolean',
            'experience.*.description' => 'sometimes|string|max:1000',
            'education' => 'sometimes|array',
            'education.*.institution' => 'required_with:education|string|max:255',
            'education.*.degree' => 'sometimes|string|max:255',
            'education.*.field' => 'sometimes|string|max:255',
            'skills' => 'sometimes|array',
            'skills.*' => 'string|max:100',
            'languages' => 'sometimes|array',
            'languages.*.name' => 'required_with:languages|string|max:100',
            'languages.*.level' => 'sometimes|string|max:50',
            'certifications' => 'sometimes|array',
            'links' => 'sometimes|array',
            'template' => 'sometimes|string|in:classic,modern,minimal',
        ]);

        $user = $request->user();

        // Мерджим существующие данные с новыми
        $existing = $this->resumeService->getResumeData($user);
        $newData = array_replace_recursive($existing, $request->only([
            'personal', 'experience', 'education', 'skills',
            'languages', 'certifications', 'links', 'template',
        ]));

        // Опыт и образование заменяем полностью (не мерджим)
        if ($request->has('experience')) {
            $newData['experience'] = $request->input('experience');
        }
        if ($request->has('education')) {
            $newData['education'] = $request->input('education');
        }
        if ($request->has('skills')) {
            $newData['skills'] = $request->input('skills');
        }
        if ($request->has('languages')) {
            $newData['languages'] = $request->input('languages');
        }
        if ($request->has('certifications')) {
            $newData['certifications'] = $request->input('certifications');
        }

        $profile = $this->resumeService->saveResumeData($user, $newData);

        return response()->json([
            'success' => true,
            'message' => 'Resume saved.',
            'data' => [
                'resume' => $newData,
                'resume_updated_at' => $profile->resume_updated_at->toISOString(),
            ],
        ]);
    }

    /**
     * GET /api/v1/candidate/resume/preview
     * HTML-превью резюме (для просмотра в браузере/WebView).
     */
    public function preview(Request $request)
    {
        $user = $request->user();
        $data = $this->resumeService->getResumeData($user);
        $template = $request->query('template', $data['template'] ?? 'classic');

        $html = $this->resumeService->renderHtml($data, $template);

        return response($html)->header('Content-Type', 'text/html');
    }

    /**
     * GET /api/v1/candidate/resume/pdf
     * Скачать PDF резюме.
     */
    public function downloadPdf(Request $request)
    {
        $user = $request->user();
        $pdf = $this->resumeService->generatePdf($user);

        $filename = str_replace(' ', '_', $user->name) . '_Resume.pdf';

        return $pdf->download($filename);
    }

    /**
     * POST /api/v1/candidate/resume/upload
     * Загрузить готовое PDF-резюме (файлом).
     */
    public function upload(Request $request): JsonResponse
    {
        $request->validate([
            'resume' => 'required|file|mimes:pdf|max:5120', // max 5MB
        ]);

        $user = $request->user();
        $profile = $user->candidateProfile;

        if (!$profile) {
            $profile = \App\Models\CandidateProfile::create([
                'user_id' => $user->id,
            ]);
        }

        $path = $request->file('resume')->store('resumes', 'public');

        $profile->update([
            'resume_path' => $path,
            'resume_updated_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Resume uploaded.',
            'data' => [
                'resume_path' => $path,
                'resume_url' => asset('storage/' . $path),
            ],
        ]);
    }
}
