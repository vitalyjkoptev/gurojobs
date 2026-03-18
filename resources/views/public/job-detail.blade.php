@extends('layouts.app')

@section('title', ($job->title ?? 'Job Details') . ' — GURO JOBS')
@section('description', Str::limit(strip_tags($job->description ?? ''), 160))

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">{{ $job->title ?? 'Job Details' }}</h1>
                    </div>
                    <div class="d-flex align-items-center justify-content-center">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb" style="background: transparent;">
                                <li class="breadcrumb-item"><a href="{{ route('home') }}" style="color: var(--guro-primary);">Home</a></li>
                                <li class="breadcrumb-item"><a href="{{ route('jobs.index') }}" style="color: var(--guro-primary);">Jobs</a></li>
                                <li class="breadcrumb-item active" aria-current="page">{{ Str::limit($job->title ?? '', 40) }}</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- End Banner -->

    <!-- Job Details -->
    <section class="job-details mb-160 md-mb-80">
        <div class="job-details-rapper">
            <div class="container">
                <div class="row g-5 d-flex align-items-start justify-content-center">

                    <!-- Company Sidebar -->
                    <div class="col-lg-4">
                        <div class="job-details-left d-flex flex-column justify-content-center">
                            <div class="left-1">
                                @if($job->company && $job->company->logo)
                                    <img src="{{ asset('storage/' . $job->company->logo) }}" alt="{{ $job->company->name }}">
                                @else
                                    <img src="{{ asset('images/slider/slider-1.png') }}" alt="Company">
                                @endif
                                <strong>{{ $job->company->name ?? 'Company' }}</strong>
                                @if($job->company && $job->company->description)
                                    <p class="mt-30">{{ Str::limit($job->company->description, 120) }}</p>
                                @endif
                            </div>

                            @if($job->company)
                                @if($job->company->jobs_count ?? false)
                                    <div class="left-1 pt-40">
                                        <p class="mb-20">Jobs Posted</p>
                                        <span>{{ $job->company->jobs_count }} {{ Str::plural('Job', $job->company->jobs_count) }}</span>
                                    </div>
                                @endif

                                @if($job->company->employee_count)
                                    <div class="left-1 pt-40">
                                        <p class="mb-20">Number Of Employees</p>
                                        <span>{{ $job->company->employee_count }}</span>
                                    </div>
                                @endif

                                @if($job->company->founded_year)
                                    <div class="left-1 pt-40">
                                        <p class="mb-20">Founded In</p>
                                        <span>{{ $job->company->founded_year }}</span>
                                    </div>
                                @endif

                                @if($job->company->website)
                                    <div class="left-1 pt-40">
                                        <p class="mb-20">Website</p>
                                        <span>
                                            <a href="{{ $job->company->website }}" target="_blank" rel="noopener" style="color: var(--guro-primary);">
                                                {{ parse_url($job->company->website, PHP_URL_HOST) }}
                                            </a>
                                        </span>
                                    </div>
                                @endif
                            @endif

                            <div class="left-1 pt-40">
                                <p class="mb-20">Location</p>
                                <span>{{ $job->location ?? 'Remote' }}</span>
                            </div>

                            @if($job->experience_level)
                                <div class="left-1 pt-40">
                                    <p class="mb-20">Experience Level</p>
                                    <span class="badge-level badge-{{ $job->experience_level->value }}">
                                        {{ $job->experience_level->label() }}
                                    </span>
                                </div>
                            @endif

                            @if($job->work_mode)
                                <div class="left-1 pt-40">
                                    <p class="mb-20">Work Mode</p>
                                    <span class="badge-level badge-{{ $job->work_mode->value }}">
                                        {{ $job->work_mode->label() }}
                                    </span>
                                </div>
                            @endif

                            @if($job->company)
                                <div class="left-2 pt-40">
                                    <a href="{{ route('jobs.index', ['company' => $job->company->slug ?? $job->company->id]) }}">View All Company Jobs</a>
                                </div>
                            @endif
                        </div>
                    </div>

                    <!-- Job Details Content -->
                    <div class="col-lg-8">
                        <div class="job-details-right">
                            <!-- Job Header Card -->
                            <div class="job-list-1 md-pt-40">
                                <div class="list-company pb-20 g-5 d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center gap-3">
                                        @if($job->company && $job->company->logo)
                                            <img src="{{ asset('storage/' . $job->company->logo) }}" alt="{{ $job->company->name }}">
                                        @else
                                            <img src="{{ asset('images/slider/slider-1.png') }}" alt="Company">
                                        @endif
                                        @if($job->experience_level)
                                            <span class="badge-level badge-{{ $job->experience_level->value }}">
                                                {{ $job->experience_level }}
                                            </span>
                                        @endif
                                        @if($job->work_mode)
                                            <span class="badge-level badge-{{ $job->work_mode->value }}">
                                                {{ $job->work_mode->label() }}
                                            </span>
                                        @endif
                                    </div>
                                    @if($job->salary_min && $job->salary_max)
                                        <span>${{ number_format($job->salary_min) }} - ${{ number_format($job->salary_max) }}</span>
                                    @elseif($job->salary_min)
                                        <span>${{ number_format($job->salary_min) }}<small>/Month</small></span>
                                    @else
                                        <span>Competitive Salary</span>
                                    @endif
                                </div>
                                <div class="job-list-name d-flex pt-20 align-items-center justify-content-between">
                                    <div class="d-flex flex-column align-items-start justify-content-start">
                                        <h4>{{ $job->title }}</h4>
                                        <div class="mt-20">
                                            <span><i class="bi bi-geo-alt"></i></span>
                                            <span>{{ $job->location ?? 'Remote' }}</span>
                                            <span><i class="bi bi-clock"></i></span>
                                            <span>{{ $job->job_type?->label() ?? 'Full-Time' }}</span>
                                            @if($job->created_at)
                                                <span><i class="bi bi-calendar"></i></span>
                                                <span>{{ $job->created_at->diffForHumans() }}</span>
                                            @endif
                                        </div>
                                    </div>
                                    <div class="job-apply d-flex align-items-center justify-content-center">
                                        @if($job->apply_url)
                                            <a href="{{ $job->apply_url }}" target="_blank" rel="noopener">Apply Now</a>
                                        @else
                                            <a href="#apply-section">Apply Now</a>
                                        @endif
                                    </div>
                                </div>
                            </div>

                            <!-- Job Description -->
                            <div class="job-list-details d-flex flex-column pt-60">
                                <h4>Job Description</h4>
                                <div class="job-description-content">
                                    {!! $job->description ?? '<p>No description available.</p>' !!}
                                </div>

                                @if($job->requirements)
                                    <h4 class="mt-50">Requirements</h4>
                                    <div class="job-requirements-content">
                                        {!! $job->requirements !!}
                                    </div>
                                @endif

                                @if($job->benefits)
                                    <h4 class="mt-50">Benefits</h4>
                                    <div class="job-benefits-content">
                                        {!! $job->benefits !!}
                                    </div>
                                @endif

                                @if($job->skills && is_array($job->skills))
                                    <h4 class="mt-50">Skills</h4>
                                    <div class="btn-group me-auto mt-20" style="flex-wrap: wrap; gap: 8px;">
                                        @foreach($job->skills as $skill)
                                            <a href="{{ route('jobs.index', ['q' => $skill]) }}" class="btn btn-primary" style="background: var(--guro-primary); border-color: var(--guro-primary);">{{ $skill }}</a>
                                        @endforeach
                                    </div>
                                @endif

                                <!-- Apply / Share Section -->
                                <div class="job-social-link d-flex align-items-center justify-content-between mt-60" id="apply-section">
                                    @if($job->apply_url)
                                        <a href="{{ $job->apply_url }}" target="_blank" rel="noopener" class="apply-btn" style="background: var(--guro-primary);">Apply For This Job</a>
                                    @elseif($job->apply_email)
                                        <a href="mailto:{{ $job->apply_email }}?subject=Application: {{ urlencode($job->title) }}" class="apply-btn" style="background: var(--guro-primary);">Apply via Email</a>
                                    @else
                                        <a href="{{ route('login') }}" class="apply-btn" style="background: var(--guro-primary);">Sign In to Apply</a>
                                    @endif
                                    <div class="job-social-link d-flex align-items-center justify-content-around">
                                        <span>Share:</span>
                                        <a href="https://www.linkedin.com/shareArticle?mini=true&url={{ urlencode(url()->current()) }}&title={{ urlencode($job->title) }}" target="_blank" class="social-link"><i class="bi bi-linkedin"></i></a>
                                        <a href="https://twitter.com/intent/tweet?text={{ urlencode($job->title . ' - Apply now!') }}&url={{ urlencode(url()->current()) }}" target="_blank" class="social-link"><i class="bi bi-twitter"></i></a>
                                        <a href="https://t.me/share/url?url={{ urlencode(url()->current()) }}&text={{ urlencode($job->title) }}" target="_blank" class="social-link"><i class="bi bi-telegram"></i></a>
                                        <a href="https://www.facebook.com/sharer/sharer.php?u={{ urlencode(url()->current()) }}" target="_blank" class="social-link"><i class="bi bi-facebook"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Related / Recent Jobs -->
    @if(isset($relatedJobs) && $relatedJobs->count())
        <section class="recent-job mb-160 md-mb-80">
            <div class="recent-job-rapper">
                <div class="container">
                    <div class="feature-job-title">
                        <h3 class="heading-3 mb-80">Related Jobs</h3>
                    </div>
                    <div class="recent-job-slider" id="recent-job-slider">
                        @foreach($relatedJobs as $related)
                            <div class="recent-job-item">
                                <div class="row pt-30 px-0 g-5">
                                    <div class="col">
                                        <div class="job-1 d-flex flex-column">
                                            <div class="job-company">
                                                <div class="company-name">
                                                    @if($related->company && $related->company->logo)
                                                        <img src="{{ asset('storage/' . $related->company->logo) }}" alt="{{ $related->company->name }}">
                                                    @else
                                                        <img src="{{ asset('images/slider/slider-' . (($loop->index % 3) + 1) . '.png') }}" alt="Company">
                                                    @endif
                                                    @if($related->work_mode)
                                                        <span class="badge-level badge-{{ $related->work_mode->value }}">{{ $related->work_mode->label() }}</span>
                                                    @else
                                                        <span>Remote</span>
                                                    @endif
                                                </div>
                                                <div class="company-taq">
                                                    <i class="bi bi-bookmark"></i>
                                                </div>
                                            </div>
                                            <div class="job-title">
                                                <h3>{{ $related->title }}</h3>
                                                @if($related->experience_level)
                                                    <span class="badge-level badge-{{ $related->experience_level->value }}">
                                                        {{ $related->experience_level->label() }}
                                                    </span>
                                                @endif
                                            </div>
                                            <div class="job-type">
                                                <span><i class="bi bi-geo-alt"></i></span>
                                                <span>{{ $related->location ?? 'Remote' }}</span>
                                                <span><i class="bi bi-clock"></i></span>
                                                <span>{{ $related->job_type?->label() ?? 'Full-Time' }}</span>
                                            </div>
                                            <div class="job-sallary pt-20">
                                                @if($related->salary_min && $related->salary_max)
                                                    <span><strong>${{ number_format($related->salary_min) }}</strong> - ${{ number_format($related->salary_max) }}</span>
                                                @elseif($related->salary_min)
                                                    <span><strong>${{ number_format($related->salary_min) }}</strong>/Month</span>
                                                @else
                                                    <span><strong>Competitive</strong></span>
                                                @endif
                                                <a href="{{ route('jobs.show', $related->slug ?? $related->id) }}">Apply Now</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </section>
    @endif

    <!-- CTA -->
    <section class="Customer-one mb-160 md-mb-80">
        <div class="container">
            <div class="customer_rapper">
                <img src="{{ asset('images/shape/shape-4.png') }}" alt="">
                <img src="{{ asset('images/shape/shape-4.png') }}" alt="">
                <div class="row">
                    <div class="col customer_content text-center pt-80 pb-80">
                        <h2>Looking for more iGaming opportunities?</h2>
                        <p class="mb-30">Browse thousands of positions from top iGaming companies worldwide.</p>
                        <a href="{{ route('jobs.index') }}" class="custom-btn">Browse All Jobs</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection

@push('scripts')
<script>
    // Track job view
    $(document).ready(function() {
        @if(isset($job) && $job->id)
        $.ajax({
            url: '/api/v1/jobs/{{ $job->id }}/view',
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content'),
                'Accept': 'application/json'
            },
            data: {},
            error: function() {
                // Silent fail for view tracking
            }
        });
        @endif
    });
</script>
@endpush
