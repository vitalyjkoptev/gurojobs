<?php

namespace App\Services;

use App\Models\Feedback;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GitHubFeedbackService
{
    protected string $token;
    protected string $repo;

    public function __construct()
    {
        $this->token = config('services.github.token', '');
        $this->repo = config('services.github.feedback_repo', 'vitalyjkoptev/gurojobs');
    }

    /**
     * Post feedback as GitHub Issue with star rating.
     */
    public function postToGitHub(Feedback $feedback): ?array
    {
        if (empty($this->token)) {
            Log::warning('GitHubFeedbackService: No GitHub token configured');
            return null;
        }

        $user = $feedback->user;
        $stars = str_repeat('⭐', $feedback->rating);
        $emptyStars = str_repeat('☆', 5 - $feedback->rating);

        $title = "{$stars}{$emptyStars} [{$feedback->rating}/5] Feedback from {$user->name}";

        $body = "## User Feedback\n\n"
            . "**Rating:** {$stars}{$emptyStars} ({$feedback->rating}/5)\n"
            . "**User:** {$user->name} ({$user->role->value})\n"
            . "**Date:** {$feedback->created_at->format('Y-m-d H:i')}\n\n"
            . "---\n\n"
            . "### Comment\n\n"
            . "> {$feedback->comment}\n\n"
            . "---\n"
            . "*Posted automatically from GURO JOBS app*";

        $labels = ['feedback'];
        if ($feedback->rating >= 4) {
            $labels[] = 'positive';
        } elseif ($feedback->rating <= 2) {
            $labels[] = 'needs-attention';
        }

        try {
            $response = Http::withToken($this->token)
                ->timeout(10)
                ->post("https://api.github.com/repos/{$this->repo}/issues", [
                    'title' => $title,
                    'body' => $body,
                    'labels' => $labels,
                ]);

            if ($response->successful()) {
                $data = $response->json();

                $feedback->update([
                    'github_issue_url' => $data['html_url'],
                    'github_issue_number' => $data['number'],
                ]);

                return $data;
            }

            Log::error('GitHub Issue creation failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return null;
        } catch (\Exception $e) {
            Log::error('GitHub Issue creation error: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Update README badge with average rating.
     */
    public function updateReadmeBadge(): void
    {
        if (empty($this->token)) return;

        $avg = Feedback::avg('rating') ?? 0;
        $count = Feedback::count();
        $avgRounded = round($avg, 1);

        // Create/update a JSON file in the repo for dynamic badge
        $badgeData = json_encode([
            'schemaVersion' => 1,
            'label' => 'User Rating',
            'message' => "{$avgRounded}/5 ({$count} reviews)",
            'color' => $avgRounded >= 4 ? 'brightgreen' : ($avgRounded >= 3 ? 'yellow' : 'red'),
        ], JSON_PRETTY_PRINT);

        try {
            // Get current file SHA (if exists)
            $getResponse = Http::withToken($this->token)
                ->get("https://api.github.com/repos/{$this->repo}/contents/.github/badge-rating.json");

            $sha = $getResponse->successful() ? $getResponse->json('sha') : null;

            $payload = [
                'message' => "Update rating badge: {$avgRounded}/5 ({$count} reviews)",
                'content' => base64_encode($badgeData),
                'committer' => [
                    'name' => 'GURO JOBS Bot',
                    'email' => 'bot@gurojobs.com',
                ],
            ];

            if ($sha) {
                $payload['sha'] = $sha;
            }

            Http::withToken($this->token)
                ->put("https://api.github.com/repos/{$this->repo}/contents/.github/badge-rating.json", $payload);
        } catch (\Exception $e) {
            Log::error('GitHub badge update error: ' . $e->getMessage());
        }
    }
}
