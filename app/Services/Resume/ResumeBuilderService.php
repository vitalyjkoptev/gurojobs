<?php

namespace App\Services\Resume;

use App\Models\CandidateProfile;
use App\Models\User;
use Barryvdh\DomPDF\Facade\Pdf;

class ResumeBuilderService
{
    /**
     * Структура resume_data (JSON):
     * {
     *   "personal": { "full_name", "email", "phone", "location", "photo_url", "summary" },
     *   "experience": [{ "company", "position", "start_date", "end_date", "current", "description" }],
     *   "education": [{ "institution", "degree", "field", "start_year", "end_year" }],
     *   "skills": ["PHP", "Laravel", ...],
     *   "languages": [{ "name", "level" }],
     *   "certifications": [{ "name", "issuer", "year" }],
     *   "links": { "linkedin", "github", "portfolio", "telegram" },
     *   "template": "classic" // classic, modern, minimal
     * }
     */

    /**
     * Получить данные резюме кандидата. Если resume_data пуст — собираем из профиля.
     */
    public function getResumeData(User $user): array
    {
        $profile = $user->candidateProfile;

        if (!$profile) {
            return $this->emptyResumeData($user);
        }

        // Если resume_data уже есть — возвращаем
        if ($profile->resume_data && !empty($profile->resume_data)) {
            return $profile->resume_data;
        }

        // Собираем из профиля
        return [
            'personal' => [
                'full_name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone ?? '',
                'location' => $profile->location ?? '',
                'photo_url' => $user->avatar ?? '',
                'summary' => $profile->bio ?? '',
            ],
            'experience' => [],
            'education' => [],
            'skills' => $profile->skills ?? [],
            'languages' => collect($profile->languages ?? [])->map(fn($l) => [
                'name' => $l, 'level' => 'Intermediate',
            ])->toArray(),
            'certifications' => [],
            'links' => [
                'linkedin' => $profile->linkedin ?? '',
                'github' => $profile->github ?? '',
                'portfolio' => $profile->portfolio ?? '',
                'telegram' => $profile->telegram ?? '',
            ],
            'template' => 'classic',
        ];
    }

    /**
     * Сохранить данные резюме.
     */
    public function saveResumeData(User $user, array $data): CandidateProfile
    {
        $profile = $user->candidateProfile;

        if (!$profile) {
            $profile = CandidateProfile::create([
                'user_id' => $user->id,
                'resume_data' => $data,
                'resume_updated_at' => now(),
            ]);
        } else {
            $profile->update([
                'resume_data' => $data,
                'resume_updated_at' => now(),
            ]);
        }

        // Синхронизируем обратно в профиль
        $this->syncProfileFromResume($profile, $data);

        return $profile->fresh();
    }

    /**
     * Генерация PDF из resume_data.
     */
    public function generatePdf(User $user): \Barryvdh\DomPDF\PDF
    {
        $data = $this->getResumeData($user);
        $template = $data['template'] ?? 'classic';

        $html = $this->renderHtml($data, $template);

        $pdf = Pdf::loadHTML($html);
        $pdf->setPaper('a4');
        $pdf->setOption('isHtml5ParserEnabled', true);
        $pdf->setOption('isRemoteEnabled', true);

        return $pdf;
    }

    /**
     * Рендерим HTML для PDF — встроенные шаблоны.
     */
    public function renderHtml(array $data, string $template = 'classic'): string
    {
        $personal = $data['personal'] ?? [];
        $experience = $data['experience'] ?? [];
        $education = $data['education'] ?? [];
        $skills = $data['skills'] ?? [];
        $languages = $data['languages'] ?? [];
        $certifications = $data['certifications'] ?? [];
        $links = $data['links'] ?? [];

        $name = e($personal['full_name'] ?? 'Candidate');
        $email = e($personal['email'] ?? '');
        $phone = e($personal['phone'] ?? '');
        $location = e($personal['location'] ?? '');
        $summary = e($personal['summary'] ?? '');

        $colors = match ($template) {
            'modern' => ['primary' => '#015EA7', 'bg' => '#f0f4f8', 'accent' => '#0077cc'],
            'minimal' => ['primary' => '#333333', 'bg' => '#ffffff', 'accent' => '#666666'],
            default => ['primary' => '#1a1a2e', 'bg' => '#ffffff', 'accent' => '#015EA7'],
        };

        $experienceHtml = '';
        foreach ($experience as $exp) {
            $period = e($exp['start_date'] ?? '') . ' — ' . ($exp['current'] ?? false ? 'Present' : e($exp['end_date'] ?? ''));
            $experienceHtml .= "
                <div class='item'>
                    <div class='item-header'>
                        <strong>" . e($exp['position'] ?? '') . "</strong>
                        <span class='period'>{$period}</span>
                    </div>
                    <div class='company'>" . e($exp['company'] ?? '') . "</div>
                    <p>" . e($exp['description'] ?? '') . "</p>
                </div>";
        }

        $educationHtml = '';
        foreach ($education as $edu) {
            $educationHtml .= "
                <div class='item'>
                    <div class='item-header'>
                        <strong>" . e($edu['degree'] ?? '') . " — " . e($edu['field'] ?? '') . "</strong>
                        <span class='period'>" . e($edu['start_year'] ?? '') . "–" . e($edu['end_year'] ?? '') . "</span>
                    </div>
                    <div class='company'>" . e($edu['institution'] ?? '') . "</div>
                </div>";
        }

        $skillsHtml = implode('', array_map(fn($s) => "<span class='skill'>" . e($s) . "</span>", $skills));

        $languagesHtml = implode('', array_map(fn($l) =>
            "<span class='skill'>" . e($l['name'] ?? '') . " (" . e($l['level'] ?? '') . ")</span>",
            $languages
        ));

        $certsHtml = '';
        foreach ($certifications as $cert) {
            $certsHtml .= "<div class='item'><strong>" . e($cert['name'] ?? '') . "</strong> — " . e($cert['issuer'] ?? '') . " (" . e($cert['year'] ?? '') . ")</div>";
        }

        $linksHtml = '';
        foreach (['linkedin', 'github', 'portfolio', 'telegram'] as $key) {
            if (!empty($links[$key])) {
                $linksHtml .= "<div>" . ucfirst($key) . ": " . e($links[$key]) . "</div>";
            }
        }

        $contactLine = implode(' | ', array_filter([$email, $phone, $location]));

        return <<<HTML
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: DejaVu Sans, Arial, sans-serif; font-size: 11px; color: #333; line-height: 1.5; padding: 30px 40px; background: {$colors['bg']}; }
    h1 { font-size: 24px; color: {$colors['primary']}; margin-bottom: 4px; }
    .contact { font-size: 10px; color: #666; margin-bottom: 15px; }
    h2 { font-size: 14px; color: {$colors['accent']}; border-bottom: 2px solid {$colors['accent']}; padding-bottom: 4px; margin: 16px 0 8px; text-transform: uppercase; letter-spacing: 1px; }
    .item { margin-bottom: 10px; }
    .item-header { display: flex; justify-content: space-between; }
    .item-header strong { font-size: 12px; }
    .period { font-size: 10px; color: #888; }
    .company { font-size: 11px; color: #555; font-style: italic; }
    .skill { display: inline-block; background: {$colors['accent']}22; color: {$colors['accent']}; padding: 2px 8px; border-radius: 3px; margin: 2px 3px 2px 0; font-size: 10px; }
    p { margin: 4px 0; font-size: 11px; }
    .summary { font-size: 11px; color: #444; margin-bottom: 10px; }
    .links { font-size: 10px; color: #555; }
    .links div { margin-bottom: 2px; }
</style>
</head>
<body>
    <h1>{$name}</h1>
    <div class="contact">{$contactLine}</div>

    {$this->section($summary, "<div class='summary'>{$summary}</div>")}

    {$this->section($experienceHtml, "<h2>Experience</h2>{$experienceHtml}")}

    {$this->section($educationHtml, "<h2>Education</h2>{$educationHtml}")}

    {$this->section($skillsHtml, "<h2>Skills</h2><div>{$skillsHtml}</div>")}

    {$this->section($languagesHtml, "<h2>Languages</h2><div>{$languagesHtml}</div>")}

    {$this->section($certsHtml, "<h2>Certifications</h2>{$certsHtml}")}

    {$this->section($linksHtml, "<h2>Links</h2><div class='links'>{$linksHtml}</div>")}
</body>
</html>
HTML;
    }

    private function section(string $content, string $html): string
    {
        return $content ? $html : '';
    }

    private function emptyResumeData(User $user): array
    {
        return [
            'personal' => [
                'full_name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone ?? '',
                'location' => '',
                'photo_url' => '',
                'summary' => '',
            ],
            'experience' => [],
            'education' => [],
            'skills' => [],
            'languages' => [],
            'certifications' => [],
            'links' => ['linkedin' => '', 'github' => '', 'portfolio' => '', 'telegram' => ''],
            'template' => 'classic',
        ];
    }

    /**
     * Синхронизируем ключевые поля обратно в CandidateProfile.
     */
    private function syncProfileFromResume(CandidateProfile $profile, array $data): void
    {
        $updates = [];

        if (!empty($data['personal']['summary']) && $data['personal']['summary'] !== $profile->bio) {
            $updates['bio'] = $data['personal']['summary'];
        }
        if (!empty($data['skills'])) {
            $updates['skills'] = $data['skills'];
        }
        if (!empty($data['languages'])) {
            $updates['languages'] = array_map(fn($l) => $l['name'] ?? $l, $data['languages']);
        }
        if (!empty($data['links'])) {
            foreach (['linkedin', 'github', 'portfolio', 'telegram'] as $key) {
                if (!empty($data['links'][$key])) {
                    $updates[$key] = $data['links'][$key];
                }
            }
        }
        if (!empty($data['personal']['location'])) {
            $updates['location'] = $data['personal']['location'];
        }

        if (!empty($updates)) {
            $profile->update($updates);
        }
    }
}
