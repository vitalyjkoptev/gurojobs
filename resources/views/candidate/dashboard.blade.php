@extends('layouts.app')

@section('title', 'My Dashboard — GURO JOBS')
@section('description', 'Your GURO JOBS candidate dashboard. Manage your profile, applications and career.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100 pb-60">
                        <h1 class="mb-30">My Dashboard</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Dashboard -->
    <section class="candidates-details mb-160 md-mb-80">
        <div class="container">
            <div class="row pt-80 g-5">
                <!-- Sidebar -->
                <div class="col-lg-4">
                    <div class="candidates-details-left">
                        <!-- Profile Card -->
                        <div class="details-left-1 d-flex flex-column align-items-center justify-content-center text-center">
                            <div class="round-pic mb-20">
                                @if($user->avatar)
                                    <img src="{{ asset('storage/' . $user->avatar) }}" alt="{{ $user->name }}">
                                @else
                                    <div style="width: 120px; height: 120px; border-radius: 50%; background: var(--guro-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 48px; font-weight: 700; margin: 0 auto;">
                                        {{ strtoupper(substr($user->name, 0, 1)) }}
                                    </div>
                                @endif
                            </div>
                            <h4 class="mt-10 mb-10">{{ $user->name }}</h4>
                            <span style="color: var(--guro-primary); font-weight: 600;">{{ $profile->headline ?? 'iGaming Professional' }}</span>
                            <div class="mt-20">
                                <span class="d-inline-block" style="background: rgba(1,94,167,0.1); color: var(--guro-primary); padding: 4px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;">
                                    <i class="bi bi-person-badge me-1"></i>Candidate
                                </span>
                            </div>
                        </div>

                        <!-- Quick Stats -->
                        <div class="details-left-2 mt-30">
                            <div class="left-1 pt-30">
                                <p class="mb-10">Applications</p>
                                <span style="font-weight: 700; font-size: 20px; color: var(--guro-primary);">{{ $applicationsCount }}</span>
                            </div>
                            <div class="left-1 pt-30">
                                <p class="mb-10">Experience Level</p>
                                <span>{{ $profile && $profile->experience_level ? $profile->experience_level->label() : 'Not set' }}</span>
                            </div>
                            <div class="left-1 pt-30">
                                <p class="mb-10">Location</p>
                                <span>{{ $profile->location ?? 'Not set' }}</span>
                            </div>
                            <div class="left-1 pt-30">
                                <p class="mb-10">Email</p>
                                <span>{{ $user->email }}</span>
                            </div>
                            @if($user->phone)
                            <div class="left-1 pt-30">
                                <p class="mb-10">Phone</p>
                                <span>{{ $user->phone }}</span>
                            </div>
                            @endif
                            <div class="left-1 pt-30">
                                <p class="mb-10">Member Since</p>
                                <span>{{ $user->created_at->format('d M Y') }}</span>
                            </div>
                        </div>

                        <!-- Community -->
                        <div class="mt-30" style="background: #fff; border-radius: 12px; padding: 24px; border: 2px solid var(--guro-primary);">
                            <div class="text-center">
                                <i class="bi bi-telegram" style="font-size: 36px; color: #0088cc;"></i>
                                <h5 class="mt-15 mb-10">Join Our Community</h5>
                                <p style="font-size: 14px; color: #666; margin-bottom: 15px;">Connect with iGaming professionals, get career tips and job alerts.</p>
                                <a href="https://t.me/+J-uze9XfjQI0NjAy" target="_blank" rel="noopener" class="custom-btn d-block text-center" style="background: #0088cc; border-color: #0088cc;">
                                    <i class="bi bi-telegram me-2"></i>Join Telegram
                                </a>
                            </div>
                        </div>

                        <!-- Logout -->
                        <div class="mt-20">
                            <form method="POST" action="{{ route('logout') }}">
                                @csrf
                                <button type="submit" class="custom-btn d-block text-center w-100" style="background: transparent; color: #dc3545; border: 2px solid #dc3545;">
                                    <i class="bi bi-box-arrow-right me-2"></i>Sign Out
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-lg-8">
                    <div class="candidates-details-right">

                        <!-- Profile Completion Alert -->
                        @if(!$profile || !$profile->headline || !$profile->bio)
                        <div style="background: #FFF3E0; border: 1px solid #FFB74D; border-radius: 12px; padding: 20px; margin-bottom: 30px;">
                            <div class="d-flex align-items-center gap-3">
                                <i class="bi bi-exclamation-triangle" style="font-size: 24px; color: #F57C00;"></i>
                                <div>
                                    <h5 class="mb-5" style="color: #E65100;">Complete Your Profile</h5>
                                    <p style="font-size: 14px; color: #666; margin: 0;">A complete profile increases your chances of getting noticed by employers. Add your headline, bio, skills and experience.</p>
                                </div>
                            </div>
                        </div>
                        @endif

                        <!-- Quick Actions -->
                        <div class="row g-4 mb-40">
                            <div class="col-md-4">
                                <a href="{{ route('jobs.index') }}" style="text-decoration: none;">
                                    <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                                        <i class="bi bi-search" style="font-size: 28px; color: var(--guro-primary);"></i>
                                        <h6 class="mt-10 mb-0">Find Jobs</h6>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="{{ route('cv-builder') }}" style="text-decoration: none;">
                                    <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                                        <i class="bi bi-file-earmark-text" style="font-size: 28px; color: var(--guro-primary);"></i>
                                        <h6 class="mt-10 mb-0">CV Builder</h6>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="https://t.me/+J-uze9XfjQI0NjAy" target="_blank" rel="noopener" style="text-decoration: none;">
                                    <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                                        <i class="bi bi-people" style="font-size: 28px; color: #0088cc;"></i>
                                        <h6 class="mt-10 mb-0">Community</h6>
                                    </div>
                                </a>
                            </div>
                        </div>

                        <!-- About -->
                        <div class="candidate-list-2">
                            <h4 class="mb-20">About</h4>
                            @if($profile && $profile->bio)
                                <p>{{ $profile->bio }}</p>
                            @else
                                <p style="color: #999; font-style: italic;">No bio added yet. Tell employers about your iGaming experience and career goals.</p>
                            @endif
                        </div>

                        <!-- Skills -->
                        <div class="candidate-list-5">
                            <h4 class="mt-40 mb-20">Skills</h4>
                            @php $skillsList = $profile && $profile->skills ? (is_array($profile->skills) ? $profile->skills : json_decode($profile->skills, true) ?? []) : []; @endphp
                            @if(count($skillsList) > 0)
                                <div class="btn-group d-inline">
                                    @foreach($skillsList as $skill)
                                        <a href="#" class="btn btn-primary">{{ $skill }}</a>
                                    @endforeach
                                </div>
                            @else
                                <p style="color: #999; font-style: italic;">No skills added yet. Add your iGaming skills to stand out.</p>
                            @endif
                        </div>

                        <!-- Recent Applications -->
                        <div class="mt-40">
                            <h4 class="mb-20">Recent Applications</h4>
                            @if($applications->count() > 0)
                                @foreach($applications as $app)
                                <div class="d-flex align-items-center justify-content-between p-3 mb-15" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                                    <div class="d-flex align-items-center gap-3">
                                        @if($app->job && $app->job->company && $app->job->company->logo)
                                            <img src="{{ asset('storage/' . $app->job->company->logo) }}" alt="" style="width: 40px; height: 40px; border-radius: 8px; object-fit: cover;">
                                        @else
                                            <div style="width: 40px; height: 40px; border-radius: 8px; background: rgba(1,94,167,0.1); display: flex; align-items: center; justify-content: center;">
                                                <i class="bi bi-building" style="color: var(--guro-primary);"></i>
                                            </div>
                                        @endif
                                        <div>
                                            <h6 class="mb-0">{{ $app->job->title ?? 'Job removed' }}</h6>
                                            <small style="color: #666;">{{ $app->job->company->name ?? '' }} &middot; {{ $app->created_at->diffForHumans() }}</small>
                                        </div>
                                    </div>
                                    <span style="padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
                                        @if($app->status === 'hired') background: #E8F5E9; color: #2E7D32;
                                        @elseif($app->status === 'shortlisted') background: #E3F2FD; color: #1565C0;
                                        @elseif($app->status === 'rejected') background: #FFEBEE; color: #C62828;
                                        @elseif($app->status === 'reviewed') background: #FFF3E0; color: #EF6C00;
                                        @else background: #F5F5F5; color: #666;
                                        @endif
                                    ">{{ ucfirst($app->status) }}</span>
                                </div>
                                @endforeach
                            @else
                                <div class="text-center p-5" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                                    <i class="bi bi-inbox" style="font-size: 48px; color: #ddd;"></i>
                                    <p class="mt-15 mb-15" style="color: #999;">No applications yet</p>
                                    <a href="{{ route('jobs.index') }}" class="custom-btn">Browse Jobs</a>
                                </div>
                            @endif
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
