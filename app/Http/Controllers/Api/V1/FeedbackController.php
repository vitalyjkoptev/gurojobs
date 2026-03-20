<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Feedback;
use App\Services\GitHubFeedbackService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FeedbackController extends Controller
{
    /**
     * Submit feedback (comment + star rating).
     */
    public function store(Request $request, GitHubFeedbackService $github): JsonResponse
    {
        $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'required|string|min:5|max:2000',
        ]);

        $user = $request->user();

        // Limit: 1 feedback per user per day
        $existing = Feedback::where('user_id', $user->id)
            ->whereDate('created_at', today())
            ->exists();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'You already submitted feedback today. Try again tomorrow.',
            ], 429);
        }

        $feedback = Feedback::create([
            'user_id' => $user->id,
            'rating' => $request->input('rating'),
            'comment' => $request->input('comment'),
        ]);

        // Post to GitHub in background (don't block the response)
        $githubResult = $github->postToGitHub($feedback);

        // Update README badge
        $github->updateReadmeBadge();

        return response()->json([
            'success' => true,
            'message' => 'Thank you for your feedback!',
            'data' => [
                'id' => $feedback->id,
                'rating' => $feedback->rating,
                'github_url' => $feedback->github_issue_url,
            ],
        ], 201);
    }

    /**
     * List all feedbacks (public).
     */
    public function index(Request $request): JsonResponse
    {
        $feedbacks = Feedback::with('user:id,name,role,avatar')
            ->latest()
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $feedbacks,
            'stats' => [
                'average' => round(Feedback::avg('rating') ?? 0, 1),
                'total' => Feedback::count(),
                'distribution' => [
                    5 => Feedback::where('rating', 5)->count(),
                    4 => Feedback::where('rating', 4)->count(),
                    3 => Feedback::where('rating', 3)->count(),
                    2 => Feedback::where('rating', 2)->count(),
                    1 => Feedback::where('rating', 1)->count(),
                ],
            ],
        ]);
    }

    /**
     * Get my feedback.
     */
    public function myFeedback(Request $request): JsonResponse
    {
        $feedbacks = Feedback::where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $feedbacks,
        ]);
    }
}
