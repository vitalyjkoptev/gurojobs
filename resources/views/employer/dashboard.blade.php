@extends('layouts.app')

@section('title', 'Employer Dashboard — GURO JOBS')
@section('description', 'Manage your company, job listings and applications on GURO JOBS.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100 pb-60">
                        <h1 class="mb-30">Employer Dashboard</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Dashboard -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="row pt-80 g-5">
                <!-- Sidebar -->
                <div class="col-lg-4">
                    <div class="candidates-details-left">
                        <!-- Company Card -->
                        <div class="details-left-1 d-flex flex-column align-items-center justify-content-center text-center">
                            @if($company && $company->logo)
                                <img src="{{ asset('storage/' . $company->logo) }}" alt="{{ $company->name }}" style="width: 100px; height: 100px; border-radius: 12px; object-fit: cover;">
                            @else
                                <div style="width: 100px; height: 100px; border-radius: 12px; background: var(--guro-primary); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 40px; font-weight: 700;">
                                    {{ strtoupper(substr($company->name ?? $user->name, 0, 1)) }}
                                </div>
                            @endif
                            <h4 class="mt-15 mb-10">{{ $company->name ?? $user->name }}</h4>
                            <span style="color: #666;">{{ $user->email }}</span>
                            <div class="mt-15">
                                <span class="d-inline-block" style="background: rgba(1,94,167,0.1); color: var(--guro-primary); padding: 4px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;">
                                    <i class="bi bi-building me-1"></i>Employer
                                </span>
                                @if($company && $company->verified)
                                <span class="d-inline-block ms-1" style="background: #E8F5E9; color: #2E7D32; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;">
                                    <i class="bi bi-patch-check-fill me-1"></i>Verified
                                </span>
                                @endif
                            </div>
                        </div>

                        <!-- Stats -->
                        <div class="details-left-2 mt-30">
                            <div class="left-1 pt-30">
                                <p class="mb-10">Active Jobs</p>
                                <span style="font-weight: 700; font-size: 20px; color: var(--guro-primary);">{{ $activeJobs }}</span>
                            </div>
                            <div class="left-1 pt-30">
                                <p class="mb-10">Total Applications</p>
                                <span style="font-weight: 700; font-size: 20px; color: var(--guro-primary);">{{ $totalApplications }}</span>
                            </div>
                            <div class="left-1 pt-30">
                                <p class="mb-10">Plan</p>
                                <span style="text-transform: capitalize;">{{ $company->plan ?? 'Free' }}</span>
                            </div>
                            @if($company && $company->location)
                            <div class="left-1 pt-30">
                                <p class="mb-10">Location</p>
                                <span>{{ $company->location }}</span>
                            </div>
                            @endif
                            @if($company && $company->website)
                            <div class="left-1 pt-30">
                                <p class="mb-10">Website</p>
                                <a href="{{ $company->website }}" target="_blank" rel="noopener" style="color: var(--guro-primary);">{{ $company->website }}</a>
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
                                <h5 class="mt-15 mb-10">Employer Community</h5>
                                <p style="font-size: 14px; color: #666; margin-bottom: 15px;">Join our Telegram community for hiring tips, networking and industry insights.</p>
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

                    <!-- Company Profile Alert -->
                    @if(!$company || !$company->description)
                    <div style="background: #FFF3E0; border: 1px solid #FFB74D; border-radius: 12px; padding: 20px; margin-bottom: 30px;">
                        <div class="d-flex align-items-center gap-3">
                            <i class="bi bi-exclamation-triangle" style="font-size: 24px; color: #F57C00;"></i>
                            <div>
                                <h5 class="mb-5" style="color: #E65100;">Complete Your Company Profile</h5>
                                <p style="font-size: 14px; color: #666; margin: 0;">Add company description, logo, and website to attract top iGaming talent.</p>
                            </div>
                        </div>
                    </div>
                    @endif

                    <!-- Quick Actions -->
                    <div class="row g-4 mb-40">
                        <div class="col-md-4">
                            <div class="text-center p-4" style="background: var(--guro-primary); border-radius: 12px; cursor: pointer;">
                                <i class="bi bi-plus-lg" style="font-size: 28px; color: #fff;"></i>
                                <h6 class="mt-10 mb-0" style="color: #fff;">Post a Job</h6>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                                <i class="bi bi-people" style="font-size: 28px; color: var(--guro-primary);"></i>
                                <h6 class="mt-10 mb-0">View Candidates</h6>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <a href="https://t.me/+J-uze9XfjQI0NjAy" target="_blank" rel="noopener" style="text-decoration: none;">
                                <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                                    <i class="bi bi-telegram" style="font-size: 28px; color: #0088cc;"></i>
                                    <h6 class="mt-10 mb-0">Community</h6>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- Company Info -->
                    <div class="candidate-list-2">
                        <h4 class="mb-20">Company Description</h4>
                        @if($company && $company->description)
                            <p>{{ $company->description }}</p>
                        @else
                            <p style="color: #999; font-style: italic;">No company description yet. Add details about your company to attract the best iGaming talent.</p>
                        @endif
                    </div>

                    <!-- Active Jobs -->
                    <div class="mt-40">
                        <div class="d-flex align-items-center justify-content-between mb-20">
                            <h4>Your Job Listings</h4>
                        </div>
                        @if($company && $company->jobs && $company->jobs->count() > 0)
                            @foreach($company->jobs()->latest()->take(5)->get() as $job)
                            <div class="d-flex align-items-center justify-content-between p-3 mb-15" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                                <div>
                                    <h6 class="mb-5">{{ $job->title }}</h6>
                                    <small style="color: #666;">
                                        {{ $job->location ?? 'Remote' }} &middot;
                                        {{ ucfirst($job->job_type ?? 'Full-time') }} &middot;
                                        Posted {{ $job->created_at->diffForHumans() }}
                                    </small>
                                </div>
                                <span style="padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
                                    @if($job->status === 'active') background: #E8F5E9; color: #2E7D32;
                                    @elseif($job->status === 'paused') background: #FFF3E0; color: #EF6C00;
                                    @elseif($job->status === 'closed') background: #FFEBEE; color: #C62828;
                                    @else background: #F5F5F5; color: #666;
                                    @endif
                                ">{{ ucfirst($job->status) }}</span>
                            </div>
                            @endforeach
                        @else
                            <div class="text-center p-5" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                                <i class="bi bi-briefcase" style="font-size: 48px; color: #ddd;"></i>
                                <p class="mt-15 mb-15" style="color: #999;">No jobs posted yet</p>
                                <p style="font-size: 14px; color: #666;">Post your first iGaming job and start receiving applications from qualified professionals.</p>
                            </div>
                        @endif
                    </div>

                    <!-- Upgrade CTA -->
                    @if(!$company || $company->plan === 'free')
                    <div class="mt-40 p-4" style="background: linear-gradient(135deg, var(--guro-primary), var(--guro-primary-light)); border-radius: 16px; color: #fff;">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <h5 style="color: #fff;" class="mb-10">Upgrade to Professional</h5>
                                <p style="color: rgba(255,255,255,0.8); margin: 0; font-size: 14px;">Get 10 active listings, featured placements, and analytics dashboard.</p>
                            </div>
                            <a href="{{ route('for-employers') }}" class="custom-btn" style="background: #fff; color: var(--guro-primary); white-space: nowrap;">View Plans</a>
                        </div>
                    </div>
                    @endif

                </div>
            </div>
        </div>
    </section>

@endsection
