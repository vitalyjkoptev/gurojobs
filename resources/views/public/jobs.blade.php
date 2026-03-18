@extends('layouts.app')

@section('title', ($searchQuery ?? false) ? 'Search: ' . $searchQuery . ' — GURO JOBS' : 'Find iGaming Jobs — GURO JOBS')
@section('description', 'Browse iGaming job listings. Filter by experience level, category, job type, and work mode. Casino, Betting, eSports, Game Development careers.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">
                            @if($searchQuery ?? false)
                                Results for "{{ $searchQuery }}"
                            @else
                                Find Your Perfect iGaming Career
                            @endif
                        </h1>
                    </div>
                    <div class="d-flex align-items-center justify-content-center mt-60">
                        <form class="form-3 d-flex align-items-center justify-content-between" action="{{ route('jobs.index') }}" method="GET">
                            <div class="item_1"><img src="{{ asset('images/icon/search.svg') }}" alt="Search"></div>
                            <div class="placeholder">
                                <input type="text" name="q" placeholder="Job title, keyword..." value="{{ $searchQuery ?? request('q') }}">
                            </div>
                            <div class="location d-flex">
                                <img src="{{ asset('images/icon/map.svg') }}" alt="Location">
                                <select name="location" class="nice-select">
                                    <option value="" data-display="Location..">Location..</option>
                                    <option value="malta" {{ request('location') == 'malta' ? 'selected' : '' }}>Malta</option>
                                    <option value="cyprus" {{ request('location') == 'cyprus' ? 'selected' : '' }}>Cyprus</option>
                                    <option value="gibraltar" {{ request('location') == 'gibraltar' ? 'selected' : '' }}>Gibraltar</option>
                                    <option value="isle-of-man" {{ request('location') == 'isle-of-man' ? 'selected' : '' }}>Isle of Man</option>
                                    <option value="curacao" {{ request('location') == 'curacao' ? 'selected' : '' }}>Curacao</option>
                                    <option value="remote" {{ request('location') == 'remote' ? 'selected' : '' }}>Remote</option>
                                    <option value="europe" {{ request('location') == 'europe' ? 'selected' : '' }}>Europe</option>
                                    <option value="asia" {{ request('location') == 'asia' ? 'selected' : '' }}>Asia</option>
                                    <option value="latam" {{ request('location') == 'latam' ? 'selected' : '' }}>LATAM</option>
                                </select>
                            </div>
                            <div class="button">
                                <button type="submit" class="custom-btn"><span>Search Now</span></button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <!-- End Banner -->

    <!-- Job Listings -->
    <section class="feature-job-list mb-160 md-mb-80">
        <div class="feature-job-list-rapper">
            <div class="container">
                <div class="row d-flex align-items-start justify-content-center px-0 gx-5">

                    <!-- Sidebar Filters -->
                    <div class="col-lg-4 md-pb-30" data-aos="zoom-in">
                        <div class="left-list d-flex flex-column">
                            <!-- Category Filter -->
                            <div class="job-type"><span>Category</span></div>
                            <div class="job-select pt-20 pb-60">
                                <select class="form-select" id="filter-category" onchange="applyFilter('category', this.value)">
                                    <option value="" {{ !request('category') ? 'selected' : '' }}>All Categories</option>
                                    @if(isset($filterCategories))
                                        @foreach($filterCategories as $cat)
                                            <option value="{{ $cat->slug }}" {{ request('category') == $cat->slug ? 'selected' : '' }}>{{ $cat->name }}</option>
                                        @endforeach
                                    @else
                                        <option value="gambling" {{ request('category') == 'gambling' ? 'selected' : '' }}>Gambling</option>
                                        <option value="betting" {{ request('category') == 'betting' ? 'selected' : '' }}>Betting</option>
                                        <option value="crypto" {{ request('category') == 'crypto' ? 'selected' : '' }}>Crypto</option>
                                        <option value="dating" {{ request('category') == 'dating' ? 'selected' : '' }}>Dating</option>
                                        <option value="e-commerce" {{ request('category') == 'e-commerce' ? 'selected' : '' }}>E-Commerce</option>
                                        <option value="fintech" {{ request('category') == 'fintech' ? 'selected' : '' }}>FinTech</option>
                                        <option value="nutra" {{ request('category') == 'nutra' ? 'selected' : '' }}>Nutra</option>
                                        <option value="other" {{ request('category') == 'other' ? 'selected' : '' }}>Other</option>
                                    @endif
                                </select>
                            </div>

                            <!-- Salary Range -->
                            <div class="job-range">
                                <strong>Salary Range</strong>
                                <div class="range d-flex flex-column align-items-center justify-content-center mt-30" id="range-slider">
                                    <div class="sallary-range d-flex align-items-center justify-content-center gx-5">
                                        <div class="field-one">
                                            <span>$</span>
                                            <label>0</label>
                                        </div>
                                        <div>-</div>
                                        <div class="field-two">
                                            <span>$</span>
                                            <label id="demo">{{ request('salary_max', '25000') }}</label>
                                        </div>
                                    </div>
                                    <input type="range" class="form-range" min="0" max="25000" value="{{ request('salary_max', '25000') }}" id="myRange">
                                </div>
                            </div>

                            <!-- Experience Level Filter -->
                            <div class="experience pt-60 pb-60 d-flex flex-column">
                                <strong>Experience Level</strong>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="c-level" id="exp-clevel"
                                               {{ request('experience_level') == 'c-level' ? 'checked' : '' }}
                                               onchange="applyFilter('experience_level', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="exp-clevel">C-Level</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $experienceCounts['c-level'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="head" id="exp-head"
                                               {{ request('experience_level') == 'head' ? 'checked' : '' }}
                                               onchange="applyFilter('experience_level', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="exp-head">Head</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $experienceCounts['head'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="senior" id="exp-senior"
                                               {{ request('experience_level') == 'senior' ? 'checked' : '' }}
                                               onchange="applyFilter('experience_level', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="exp-senior">Senior</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $experienceCounts['senior'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="middle" id="exp-middle"
                                               {{ request('experience_level') == 'middle' ? 'checked' : '' }}
                                               onchange="applyFilter('experience_level', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="exp-middle">Middle</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $experienceCounts['middle'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="junior" id="exp-junior"
                                               {{ request('experience_level') == 'junior' ? 'checked' : '' }}
                                               onchange="applyFilter('experience_level', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="exp-junior">Junior</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $experienceCounts['junior'] ?? '--' }}</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Job Type Filter -->
                            <div class="experience d-flex flex-column">
                                <strong>Job Type</strong>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="full-time" id="type-fulltime"
                                               {{ request('job_type') == 'full-time' ? 'checked' : '' }}
                                               onchange="applyFilter('job_type', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="type-fulltime">Full Time</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $jobTypeCounts['full-time'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="part-time" id="type-parttime"
                                               {{ request('job_type') == 'part-time' ? 'checked' : '' }}
                                               onchange="applyFilter('job_type', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="type-parttime">Part Time</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $jobTypeCounts['part-time'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="contract" id="type-contract"
                                               {{ request('job_type') == 'contract' ? 'checked' : '' }}
                                               onchange="applyFilter('job_type', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="type-contract">Contract</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $jobTypeCounts['contract'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="freelance" id="type-freelance"
                                               {{ request('job_type') == 'freelance' ? 'checked' : '' }}
                                               onchange="applyFilter('job_type', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="type-freelance">Freelance</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $jobTypeCounts['freelance'] ?? '--' }}</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Work Mode Filter -->
                            <div class="experience pt-60 d-flex flex-column">
                                <strong>Work Mode</strong>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="remote" id="mode-remote"
                                               {{ request('work_mode') == 'remote' ? 'checked' : '' }}
                                               onchange="applyFilter('work_mode', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="mode-remote">Remote</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $workModeCounts['remote'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="hybrid" id="mode-hybrid"
                                               {{ request('work_mode') == 'hybrid' ? 'checked' : '' }}
                                               onchange="applyFilter('work_mode', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="mode-hybrid">Hybrid</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $workModeCounts['hybrid'] ?? '--' }}</span>
                                    </div>
                                </div>
                                <div class="left-side pb-20 d-flex align-items-center justify-content-between">
                                    <div class="form-check d-flex align-items-center justify-content-between">
                                        <input class="form-check-input" type="checkbox" value="onsite" id="mode-onsite"
                                               {{ request('work_mode') == 'onsite' ? 'checked' : '' }}
                                               onchange="applyFilter('work_mode', this.checked ? this.value : '')">
                                        <label class="form-check-label" for="mode-onsite">On-site</label>
                                    </div>
                                    <div class="right-side d-flex align-items-center justify-content-center">
                                        <span>{{ $workModeCounts['onsite'] ?? '--' }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Job Listings Column -->
                    <div class="col-lg-8">
                        <div class="right-job-list">
                            <div class="job-list-heading pb-40 d-flex align-items-center justify-content-between">
                                <strong>
                                    @if(isset($jobs) && $jobs->total())
                                        Showing {{ $jobs->total() }} {{ Str::plural('Job', $jobs->total()) }}
                                    @else
                                        No jobs found
                                    @endif
                                </strong>
                                <div class="sort-list d-flex align-items-center justify-content-around">
                                    <strong>Sort by</strong>
                                    <div>
                                        <select class="form-select" id="sort-select" onchange="applyFilter('sort', this.value)">
                                            <option value="newest" {{ request('sort', 'newest') == 'newest' ? 'selected' : '' }}>Newest</option>
                                            <option value="salary-high" {{ request('sort') == 'salary-high' ? 'selected' : '' }}>Salary: High to Low</option>
                                            <option value="salary-low" {{ request('sort') == 'salary-low' ? 'selected' : '' }}>Salary: Low to High</option>
                                            <option value="title" {{ request('sort') == 'title' ? 'selected' : '' }}>Title A-Z</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            @if(isset($jobs) && $jobs->count())
                                @foreach($jobs as $job)
                                    <div class="job-list-1 {{ !$loop->first ? 'mt-40' : '' }}">
                                        <div class="list-company pb-20 d-flex align-items-center justify-content-between">
                                            <div class="d-flex align-items-center gap-3">
                                                @if($job->company && $job->company->logo)
                                                    <img src="{{ asset('storage/' . $job->company->logo) }}" alt="{{ $job->company->name }}">
                                                @else
                                                    <img src="{{ asset('images/slider/slider-1.png') }}" alt="Company">
                                                @endif
                                                @if($job->experience_level)
                                                    <span class="badge-level badge-{{ $job->experience_level->value }}">
                                                        {{ $job->experience_level->label() }}
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
                                                <h4>
                                                    <a href="{{ route('jobs.show', $job->slug ?? $job->id) }}" style="text-decoration: none; color: inherit;">
                                                        {!! $job->highlight['title'] ?? e($job->title) !!}
                                                    </a>
                                                </h4>
                                                <div class="mt-20">
                                                    <span><i class="bi bi-geo-alt"></i></span>
                                                    <span>{{ $job->location ?? 'Remote' }}</span>
                                                    <span><i class="bi bi-clock"></i></span>
                                                    <span>{{ $job->job_type?->label() ?? 'Full-Time' }}</span>
                                                    @if($job->company)
                                                        <span><i class="bi bi-building"></i></span>
                                                        <span>{{ $job->company->name }}</span>
                                                    @endif
                                                </div>
                                            </div>
                                            <div class="job-apply d-flex align-items-center justify-content-center">
                                                <a href="{{ route('jobs.show', $job->slug ?? $job->id) }}">Apply Now</a>
                                            </div>
                                        </div>
                                    </div>
                                @endforeach

                                <!-- Pagination -->
                                @if($jobs->hasPages())
                                    <div class="job-list-pagination d-flex align-items-center pt-80">
                                        {{ $jobs->appends(request()->query())->links('pagination::bootstrap-5') }}
                                    </div>
                                @endif
                            @else
                                <div class="text-center py-5">
                                    <i class="bi bi-search" style="font-size: 48px; color: #ccc;"></i>
                                    <h4 class="mt-3">No jobs found</h4>
                                    <p class="text-muted">Try adjusting your search criteria or browse all jobs.</p>
                                    <a href="{{ route('jobs.index') }}" class="custom-btn mt-3">Browse All Jobs</a>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="Customer-one mb-160 md-mb-80">
        <div class="container">
            <div class="customer_rapper">
                <img src="{{ asset('images/shape/shape-4.png') }}" alt="">
                <img src="{{ asset('images/shape/shape-4.png') }}" alt="">
                <div class="row">
                    <div class="col customer_content text-center pt-80 pb-80">
                        <h2>Can't find what you're looking for?</h2>
                        <p class="mb-30">Create a profile and let iGaming employers find you. Get notified when new jobs match your skills.</p>
                        <a href="{{ route('register') }}" class="custom-btn">Create Profile</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection

@push('scripts')
<script>
    // Filter helper: updates URL params and reloads
    function applyFilter(key, value) {
        var url = new URL(window.location.href);
        if (value) {
            url.searchParams.set(key, value);
        } else {
            url.searchParams.delete(key);
        }
        // Reset pagination on filter change
        url.searchParams.delete('page');
        window.location.href = url.toString();
    }

    // Salary range slider
    $(document).ready(function() {
        var slider = document.getElementById('myRange');
        var output = document.getElementById('demo');
        if (slider && output) {
            slider.oninput = function() {
                output.textContent = this.value;
            };
        }
    });
</script>
@endpush
