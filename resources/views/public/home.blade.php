@extends('layouts.app')

@section('title', 'GURO JOBS — Find Your Dream iGaming Career')
@section('description', 'The leading job portal for the iGaming industry. Casino, Betting, eSports, Game Development, Poker, Slots, Sportsbook and more.')

@section('content')

    <!-- Banner / Hero Section -->
    <div class="banner-one mb-160 sm-mb-90">
        <div class="container">
            <div class="banner-one-rapper">
                <div class="row g-5 d-flex align-items-center justify-content-md-center">
                    <!-- Left side content -->
                    <div class="col-lg-6 g-5 left_banner pt-160 sm-pt-90">
                        <h1 class="hero-heading">Find Your Dream iGaming Job with <span>GURO JOBS.</span></h1>
                        <form class="mt-50" action="{{ route('jobs.index') }}" method="GET" style="position: relative;">
                        <style>.banner-one form::after { display: none !important; }</style>
                            <div class="item_1"><img src="{{ asset('images/icon/search.svg') }}" alt="Search"></div>
                            <div class="item_2" style="left: 0;">
                                <input type="text" name="q" id="hero-search" placeholder="" value="{{ old('q') }}">
                            </div>
                            <div class="item_3">
                                <div class="location d-flex">
                                    <img src="{{ asset('images/icon/map.svg') }}" alt="Location">
                                    <select name="location" class="nice-select">
                                        <option value="" data-display="Location..">Location..</option>
                                        <option value="malta">Malta</option>
                                        <option value="cyprus">Cyprus</option>
                                        <option value="gibraltar">Gibraltar</option>
                                        <option value="isle-of-man">Isle of Man</option>
                                        <option value="curacao">Curacao</option>
                                        <option value="remote">Remote</option>
                                        <option value="europe">Europe</option>
                                        <option value="asia">Asia</option>
                                        <option value="latam">LATAM</option>
                                    </select>
                                </div>
                            </div>
                            <div class="item_4">
                                <button type="submit" class="custom-btn"><i class="bi bi-search"></i></button>
                            </div>
                        </form>

                    </div>
                    <!-- Right side image -->
                    <div class="col-lg-5 offset-lg-1">
                        <div class="right_banner pt-160">
                            <img src="{{ asset('images/banner/banner-1.jpg') }}" alt="iGaming Jobs" class="banner-img0" style="border-radius: 20px; box-shadow: 0 10px 40px rgba(1,94,167,0.15);">
                            <a href="#"><img src="{{ asset('images/screen/screen-1.svg') }}" alt="20K+ Secure Jobs" class="banner-img1"></a>
                            <a href="#"><img src="{{ asset('images/screen/screen-2.svg') }}" alt="1.2M Revenue" class="banner-img2"></a>
                            <a href="#"><img src="{{ asset('images/screen/screen-3.svg') }}" alt="10K+ Real Customers" class="banner-img3"></a>
                            <img src="{{ asset('images/shape/shape-1.png') }}" alt="" class="shape1">
                            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape2">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- End Banner -->

    <!-- Partner / Trusted Companies Slider -->
    <section class="Partner">
        <div class="container">
            <div class="partner-text">
                <h3 class="heading text-center">Trusted by <span>100+</span> iGaming Companies</h3>
            </div>
            <div class="row">
                <div class="main-content pt-60 pb-160 md-pb-80">
                    <div id="partner_slider">
                        <div class="item"><img src="{{ asset('images/slider/slider-1.svg') }}" alt="Evolution Gaming"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-2.svg') }}" alt="Betsson Group"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-3.svg') }}" alt="Pragmatic Play"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-4.svg') }}" alt="LeoVegas"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-5.svg') }}" alt="Playtech"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-6.svg') }}" alt="Entain"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-7.svg') }}" alt="Microgaming"></div>
                        <div class="item"><img src="{{ asset('images/slider/slider-8.svg') }}" alt="Pinnacle"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- iGaming Categories -->
    <section class="categoty theme-one-category pb-160 md-pb-90">
        <div class="container">
            <div class="category-rapper">
                <h3 class="heading text-justify pb-60">Explore iGaming <span>Categories</span></h3>
                <div class="row first-row pb-20 md-p0 gy-4">
                    @if(isset($categories) && $categories->count())
                        @foreach($categories->take(8) as $category)
                            <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12">
                                <div class="job-category-one">
                                    @php
                                        $iconMap = ['gambling'=>'icon_gambling.png','betting'=>'icon_betting.png','crypto'=>'icon_crypto.png','dating'=>'icon_dating.png','e-commerce'=>'icon_ecommerce.png','fintech'=>'icon_fintech.png','nutra'=>'icon_nutra.png','other'=>'icon_other.png'];
                                        $iconFile = $iconMap[$category->slug] ?? 'icon_other.png';
                                    @endphp
                                    <div class="job-icon-one {{ $loop->iteration > 1 ? 'job-icon-' . (['two','three','four','five','six','seven','eight'][$loop->index - 1] ?? '') : '' }} d-flex align-items-center justify-content-center">
                                        <img src="{{ asset('images/categories/' . $iconFile) }}" alt="{{ $category->name }}" style="width: 48px; height: 48px; filter: brightness(0) saturate(100%) invert(23%) sepia(89%) saturate(2068%) hue-rotate(192deg) brightness(91%) contrast(101%) drop-shadow(0 0 0.5px #015EA7);">
                                    </div>
                                    <h4 class="category-heading pt-20">{{ $category->name }}</h4>
                                    <a href="{{ route('jobs.index', ['category' => $category->slug]) }}" class="category-link pt-20">{{ $category->jobs_count ?? 0 }} Jobs</a>
                                </div>
                            </div>
                        @endforeach
                    @else
                        {{-- Fallback categories (synced with mobile app) --}}
                        @php
                            $fallbackCats = [
                                ['name'=>'Gambling','slug'=>'gambling','icon'=>'icon_gambling.png','css'=>''],
                                ['name'=>'Betting','slug'=>'betting','icon'=>'icon_betting.png','css'=>'job-icon-two'],
                                ['name'=>'Crypto','slug'=>'crypto','icon'=>'icon_crypto.png','css'=>'job-icon-three'],
                                ['name'=>'Dating','slug'=>'dating','icon'=>'icon_dating.png','css'=>'job-icon-four'],
                                ['name'=>'E-Commerce','slug'=>'e-commerce','icon'=>'icon_ecommerce.png','css'=>'job-icon-five'],
                                ['name'=>'FinTech','slug'=>'fintech','icon'=>'icon_fintech.png','css'=>'job-icon-six'],
                                ['name'=>'Nutra','slug'=>'nutra','icon'=>'icon_nutra.png','css'=>'job-icon-seven'],
                                ['name'=>'Other','slug'=>'other','icon'=>'icon_other.png','css'=>'job-icon-eight'],
                            ];
                        @endphp
                        @foreach($fallbackCats as $fc)
                        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12">
                            <div class="job-category-one">
                                <div class="job-icon-one {{ $fc['css'] }} d-flex align-items-center justify-content-center">
                                    <img src="{{ asset('images/categories/' . $fc['icon']) }}" alt="{{ $fc['name'] }}" style="width: 48px; height: 48px; filter: brightness(0) saturate(100%) invert(23%) sepia(89%) saturate(2068%) hue-rotate(192deg) brightness(91%) contrast(101%) drop-shadow(0 0 0.5px #015EA7);">
                                </div>
                                <h4 class="category-heading pt-20">{{ $fc['name'] }}</h4>
                                <a href="{{ route('jobs.index', ['category' => $fc['slug']]) }}" class="category-link pt-20">Browse Jobs</a>
                            </div>
                        </div>
                        @endforeach
                    @endif
                </div>
            </div>
        </div>
    </section>

    <!-- About Us -->
    <section class="about-us position-relative pb-160 md-pb-90">
        <div class="container">
            <div class="about-us-rapper position-relative">
                <img src="{{ asset('images/shape/shape-5.png') }}" alt="" class="shape shape-5">
                <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-6">
                <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-7">
                <div class="row d-flex align-items-center justify-content-center">
                    <div class="col-lg-6">
                        <div class="left-about-one">
                            <img src="{{ asset('images/banner/banner-2.jpg') }}" alt="" class="pic-one">
                            <img src="{{ asset('images/screen/screen-4.svg') }}" alt="2450+ iGaming Jobs" class="pic-two">
                            <img src="{{ asset('images/screen/screen-5.svg') }}" alt="30+ Countries" class="pic-three">
                            <img src="{{ asset('images/screen/screen-6.svg') }}" alt="100+ Companies" class="pic-four">
                            <img src="{{ asset('images/shape/shape-4.png') }}" alt="" class="pic-five">
                        </div>
                    </div>
                    <div class="col-lg-5 offset-lg-1">
                        <div class="right-about md-mt-50">
                            <span class="span-one">About GURO JOBS</span>
                            <h2 class="heading-2 mt-20 md-mt-20">Find Your Perfect iGaming Career Based on Experience</h2>
                            <p class="md-mt-20">Whether you're a C-Level executive or a Junior starting your career, GURO JOBS connects top talent with leading iGaming companies worldwide. Casino, Betting, eSports, Game Development -- your dream role is here.</p>
                            <a href="{{ route('about') }}" class="md-mt-20">More Details</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Jobs -->
    <section class="feature-job mb-160 md-mb-90">
        <div class="feature-job-rapper pt-80 pb-80">
            <div class="container">
                <div class="text-center feature-job-title">
                    <span class="span-one">FEATURED JOBS</span>
                    <h2 class="heading-2 mt-20 mb-60 md-p0">Top iGaming Positions</h2>
                </div>
                <div class="row px-0 gy-4">
                    @if(isset($featuredJobs) && $featuredJobs->count())
                        @foreach($featuredJobs->take(6) as $job)
                            <div class="col-lg-4 col-md-6 col-sm-12">
                                <div class="job-1 d-flex flex-column">
                                    <div class="job-company">
                                        <div class="company-name">
                                            @if($job->company && $job->company->logo)
                                                <img src="{{ asset('storage/' . $job->company->logo) }}" alt="{{ $job->company->name }}">
                                            @else
                                                <img src="{{ asset('images/slider/slider-' . (($loop->index % 8) + 1) . '.svg') }}" alt="Company">
                                            @endif
                                            @if($job->work_mode)
                                                <span class="badge-level badge-{{ $job->work_mode->value }}">{{ $job->work_mode->label() }}</span>
                                            @else
                                                <span>Remote</span>
                                            @endif
                                        </div>
                                        <div class="company-taq">
                                            <i class="bi bi-bookmark"></i>
                                        </div>
                                    </div>
                                    <div class="job-title">
                                        <h3>{{ $job->title }}</h3>
                                        @if($job->experience_level)
                                            <span class="badge-level badge-{{ $job->experience_level->value }}">
                                                {{ $job->experience_level->label() }}
                                            </span>
                                        @endif
                                    </div>
                                    <div class="job-type">
                                        <span><i class="bi bi-geo-alt"></i></span>
                                        <span>{{ $job->location ?? 'Remote' }}</span>
                                        <span><i class="bi bi-clock"></i></span>
                                        <span>{{ $job->job_type?->label() ?? 'Full-Time' }}</span>
                                    </div>
                                    <div class="job-sallary">
                                        @if($job->salary_min && $job->salary_max)
                                            <span><strong>${{ number_format($job->salary_min) }}</strong> - ${{ number_format($job->salary_max) }}</span>
                                        @elseif($job->salary_min)
                                            <span><strong>${{ number_format($job->salary_min) }}</strong>/Month</span>
                                        @else
                                            <span><strong>Competitive</strong></span>
                                        @endif
                                        <a href="{{ route('jobs.show', $job->slug ?? $job->id) }}">Apply Now</a>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    @else
                        {{-- Placeholder featured jobs --}}
                        @php
                            $placeholders = [
                                ['title' => 'Head of Casino Operations', 'location' => 'Malta', 'type' => 'Full-Time', 'salary' => '$12,000', 'level' => 'Head', 'company' => 'EVOLUTION', 'logo' => 1],
                                ['title' => 'Senior Sports Betting Analyst', 'location' => 'Cyprus', 'type' => 'Full-Time', 'salary' => '$8,000', 'level' => 'Senior', 'company' => 'BETSSON', 'logo' => 2],
                                ['title' => 'Game Producer - Slots', 'location' => 'Remote', 'type' => 'Full-Time', 'salary' => '$7,500', 'level' => 'Middle', 'company' => 'PRAGMATIC', 'logo' => 3],
                                ['title' => 'Chief Technology Officer', 'location' => 'Gibraltar', 'type' => 'Full-Time', 'salary' => '$18,000', 'level' => 'C-Level', 'company' => 'LEOVEGAS', 'logo' => 4],
                                ['title' => 'eSports Community Manager', 'location' => 'Remote', 'type' => 'Full-Time', 'salary' => '$4,500', 'level' => 'Middle', 'company' => 'PLAYTECH', 'logo' => 5],
                                ['title' => 'Junior QA Tester - Casino', 'location' => 'Malta', 'type' => 'Full-Time', 'salary' => '$2,500', 'level' => 'Junior', 'company' => 'ENTAIN', 'logo' => 6],
                            ];
                        @endphp
                        @foreach($placeholders as $i => $ph)
                            <div class="col-lg-4 col-md-6 col-sm-12">
                                <div class="job-1 d-flex flex-column">
                                    <div class="job-company">
                                        <div class="company-name">
                                            <img src="{{ asset('images/slider/slider-' . $ph['logo'] . '.svg') }}" alt="{{ $ph['company'] }}">
                                            <span>Remote</span>
                                        </div>
                                        <div class="company-taq">
                                            <i class="bi bi-bookmark"></i>
                                        </div>
                                    </div>
                                    <div class="job-title">
                                        <h3>{{ $ph['title'] }}</h3>
                                        <span class="badge-level badge-{{ str_replace(' ', '-', strtolower($ph['level'])) }}">{{ $ph['level'] }}</span>
                                    </div>
                                    <div class="job-type">
                                        <span><i class="bi bi-geo-alt"></i></span>
                                        <span>{{ $ph['location'] }}</span>
                                        <span><i class="bi bi-clock"></i></span>
                                        <span>{{ $ph['type'] }}</span>
                                    </div>
                                    <div class="job-sallary">
                                        <span><strong>{{ $ph['salary'] }}</strong>/Month</span>
                                        <a href="{{ route('jobs.index') }}">Apply Now</a>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    @endif
                </div>
                <div class="explore-btn">
                    <a href="{{ route('jobs.index') }}" class="btn-custom">Explore All Jobs</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Why Choose Us -->
    <section class="why-choose-us mb-160 md-mb-120">
        <div class="container">
            <div class="why-choose-us-rapper position-relative">
                <img src="{{ asset('images/shape/shape-5.png') }}" alt="" class="shape shape-5">
                <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-6">
                <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-7">
                <div class="row d-flex align-items-center justify-content-center">
                    <div class="row d-flex align-items-center justify-content-center">
                        <div class="col-xl-5 left-choose-content">
                            <div class="choose-us-heading">
                                <span class="span-one">Why Choose Us</span>
                                <h2 class="text-justify mb-20 mt-20"><span>GURO JOBS</span> -- Your Gateway to iGaming Careers</h2>
                                <p>We specialize exclusively in the iGaming industry, connecting top talent with leading operators, game studios, and service providers worldwide.</p>
                                <ul class="mb-30 mt-30">
                                    <li><span><i class="bi bi-shield-check"></i></span><a href="{{ route('about') }}">Verified iGaming Companies</a></li>
                                    <li><span><i class="bi bi-lightning"></i></span><a href="{{ route('jobs.index') }}">AI-Powered Job Matching</a></li>
                                    <li><span><i class="bi bi-globe"></i></span><a href="{{ route('about') }}">Global iGaming Network</a></li>
                                </ul>
                                <a href="{{ route('jobs.index') }}" class="custom-btn">Browse Jobs</a>
                            </div>
                        </div>
                        <div class="col-xl-6 offset-xl-1 lg-mt-80 md-mt-80">
                            <div class="right-choose-content position-relative">
                                <img src="{{ asset('images/banner/banner-3.jpg') }}" alt="iGaming Careers" class="img-fluid">
                                <span></span>
                                <span></span>
                                <span></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="Customer-one mb-160 md-mb-80">
        <div class="container">
            <div class="customer_rapper">
                <img src="{{ asset('images/shape/shape-4.png') }}" alt="">
                <img src="{{ asset('images/shape/shape-4.png') }}" alt="">
                <div class="row">
                    <div class="col customer_content text-center pt-80 pb-80">
                        <h2>Join 10,000+ iGaming Professionals. Start Your Career Today!</h2>
                        <p class="mb-30">From Casino Operations to Game Development, find your next role in the world's fastest-growing entertainment industry.</p>
                        <a href="{{ route('jobs.index') }}" class="custom-btn">Browse Jobs Now</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
