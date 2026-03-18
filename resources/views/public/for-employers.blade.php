@extends('layouts.app')

@section('title', 'For Employers — GURO JOBS')
@section('description', 'Hire top iGaming talent on GURO JOBS. Post jobs, manage applicants, build your employer brand in Casino, Betting, eSports and Game Development.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">Hire iGaming Talent</h1>
                    </div>
                    <p style="max-width: 620px; margin: 0 auto; color: #666; font-size: 17px;">The #1 job platform for the iGaming industry. Post vacancies, manage applicants and build your employer brand — all in one place.</p>
                    <div class="mt-30 d-flex gap-3 justify-content-center flex-wrap">
                        <a href="{{ route('register') }}" class="custom-btn">Post a Job Now</a>
                        <a href="#pricing" class="custom-btn" style="background: #fff; color: var(--guro-primary); border: 2px solid var(--guro-primary);">View Pricing</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- How It Works -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="text-center mb-80">
                <h2 class="heading-2">How It <span style="color: var(--guro-primary);">Works</span></h2>
                <p style="max-width: 500px; margin: 10px auto 0; color: #666;">Start hiring iGaming professionals in 3 simple steps.</p>
            </div>
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="text-center p-4">
                        <div style="width: 80px; height: 80px; background: rgba(1,94,167,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <span style="font-size: 32px; font-weight: 800; color: var(--guro-primary);">1</span>
                        </div>
                        <h5 class="mb-10">Create Company Profile</h5>
                        <p style="color: #666; font-size: 15px;">Register, add your company details, logo and description. Show candidates who you are and why they should join.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="text-center p-4">
                        <div style="width: 80px; height: 80px; background: rgba(1,94,167,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <span style="font-size: 32px; font-weight: 800; color: var(--guro-primary);">2</span>
                        </div>
                        <h5 class="mb-10">Post Your Vacancies</h5>
                        <p style="color: #666; font-size: 15px;">Create detailed job listings with role, salary, location and requirements. Reach thousands of iGaming professionals instantly.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="text-center p-4">
                        <div style="width: 80px; height: 80px; background: rgba(1,94,167,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;">
                            <span style="font-size: 32px; font-weight: 800; color: var(--guro-primary);">3</span>
                        </div>
                        <h5 class="mb-10">Manage &amp; Hire</h5>
                        <p style="color: #666; font-size: 15px;">Review applications, track candidates and manage the entire hiring pipeline from your employer dashboard.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Employer Features -->
    <section class="mb-160 md-mb-80" style="background: var(--guro-bg); padding: 80px 0;">
        <div class="container">
            <div class="text-center mb-60">
                <h2 class="heading-2">Employer <span style="color: var(--guro-primary);">Dashboard</span></h2>
                <p style="max-width: 550px; margin: 10px auto 0; color: #666;">Everything you need to manage your hiring process efficiently.</p>
            </div>
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                            <i class="bi bi-briefcase" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Job Management</h5>
                        <p style="color: #666; font-size: 14px;">Create, edit, pause and republish job listings. Set expiry dates, salary ranges and location preferences.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                            <i class="bi bi-people" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Applicant Tracking</h5>
                        <p style="color: #666; font-size: 14px;">Review applications with candidate profiles, CVs and cover letters. Move candidates through hiring stages.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                            <i class="bi bi-building" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Company Profile</h5>
                        <p style="color: #666; font-size: 14px;">Showcase your brand with logo, description, tech stack and culture. Stand out to top iGaming talent.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                            <i class="bi bi-bar-chart" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Analytics &amp; Insights</h5>
                        <p style="color: #666; font-size: 14px;">Track job views, clicks and applications. Understand which listings perform best and optimize your hiring.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                            <i class="bi bi-star" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Featured Listings</h5>
                        <p style="color: #666; font-size: 14px;">Boost visibility with featured placements. Your jobs appear at the top of search results and category pages.</p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px;">
                            <i class="bi bi-envelope" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Email Notifications</h5>
                        <p style="color: #666; font-size: 14px;">Get instant alerts when candidates apply. Never miss a qualified applicant — respond fast and hire faster.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Why GURO JOBS -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="text-center mb-60">
                <h2 class="heading-2">Why <span style="color: var(--guro-primary);">GURO JOBS</span>?</h2>
            </div>
            <div class="row g-5">
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex gap-3">
                        <div style="min-width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-controller" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <div>
                            <h5 class="mb-10">iGaming Only</h5>
                            <p style="color: #666; font-size: 15px;">100% focused on the iGaming industry. Casino, Betting, eSports, Game Development — no irrelevant profiles.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex gap-3">
                        <div style="min-width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-speedometer2" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <div>
                            <h5 class="mb-10">Fast Results</h5>
                            <p style="color: #666; font-size: 15px;">Average time to first qualified application — under 48 hours. Get candidates when you need them.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex gap-3">
                        <div style="min-width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-globe" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <div>
                            <h5 class="mb-10">Global Reach</h5>
                            <p style="color: #666; font-size: 15px;">Attract talent from Malta, Cyprus, Gibraltar, Curacao and remote workers worldwide.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex gap-3">
                        <div style="min-width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-shield-check" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <div>
                            <h5 class="mb-10">Verified Candidates</h5>
                            <p style="color: #666; font-size: 15px;">Professional profiles with skills, experience and verified iGaming background. Quality over quantity.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex gap-3">
                        <div style="min-width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-credit-card" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <div>
                            <h5 class="mb-10">Flexible Payment</h5>
                            <p style="color: #666; font-size: 15px;">Pay with card or crypto. Cancel anytime. No long-term contracts required.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="d-flex gap-3">
                        <div style="min-width: 50px; height: 50px; background: rgba(1,94,167,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-headset" style="font-size: 22px; color: var(--guro-primary);"></i>
                        </div>
                        <div>
                            <h5 class="mb-10">Dedicated Support</h5>
                            <p style="color: #666; font-size: 15px;">Our team knows iGaming. Get industry-specific advice on job descriptions, salary benchmarks and hiring strategy.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- iGaming Categories -->
    <section class="mb-160 md-mb-80" style="background: var(--guro-bg); padding: 80px 0;">
        <div class="container">
            <div class="text-center mb-60">
                <h2 class="heading-2">Hire Across All <span style="color: var(--guro-primary);">iGaming Verticals</span></h2>
                <p style="max-width: 550px; margin: 10px auto 0; color: #666;">Whatever your niche — we have the candidates.</p>
            </div>
            <div class="row g-3 justify-content-center">
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'gambling']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-controller" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">Gambling</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'betting']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-trophy" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">Betting</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'crypto']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-currency-bitcoin" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">Crypto</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'dating']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-heart" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">Dating</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'e-commerce']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-cart3" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">E-Commerce</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'fintech']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-bank" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">FinTech</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'nutra']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-capsule" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">Nutra</h6>
                        </div>
                    </a>
                </div>
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => 'other']) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <i class="bi bi-grid" style="font-size: 28px; color: var(--guro-primary); display: block; margin-bottom: 10px;"></i>
                            <h6 style="font-size: 14px; margin: 0; color: #333;">Other</h6>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing Plans -->
    <section class="mb-160 md-mb-80" id="pricing">
        <div class="container">
            <div class="text-center mb-80">
                <h2 class="heading-2">Simple <span style="color: var(--guro-primary);">Pricing</span></h2>
                <p style="max-width: 500px; margin: 10px auto 0; color: #666;">Choose the plan that fits your hiring needs.</p>
            </div>
            <div class="row g-4 d-flex align-items-stretch justify-content-center">
                <!-- Starter -->
                <div class="col-lg-4 col-md-6">
                    <div class="p-5 h-100 d-flex flex-column" style="background: #fff; border-radius: 16px; border: 2px solid #eee; transition: all 0.3s;">
                        <h4 class="mb-10">Starter</h4>
                        <div class="mb-20">
                            <span style="font-size: 40px; font-weight: 800; color: var(--guro-text);">&euro;10</span>
                            <span style="color: #999;">/month</span>
                        </div>
                        <p style="color: #666;" class="mb-30">Perfect to start hiring in iGaming.</p>
                        <ul style="list-style: none; padding: 0; flex: 1;">
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>3 Active Job Postings</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Basic Company Profile</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>30 Days Listing</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Email Applications</li>
                            <li class="mb-15" style="color: #ccc;"><i class="bi bi-x-circle me-2"></i>Featured Listing</li>
                            <li class="mb-15" style="color: #ccc;"><i class="bi bi-x-circle me-2"></i>Analytics Dashboard</li>
                        </ul>
                        <a href="{{ route('register') }}" class="custom-btn text-center" style="display: block; background: #fff; color: var(--guro-primary); border: 2px solid var(--guro-primary);">Get Started</a>
                    </div>
                </div>
                <!-- Professional -->
                <div class="col-lg-4 col-md-6">
                    <div class="p-5 h-100 d-flex flex-column" style="background: #fff; border-radius: 16px; border: 2px solid var(--guro-primary); position: relative; transition: all 0.3s;">
                        <span style="position: absolute; top: -12px; left: 50%; transform: translateX(-50%); background: var(--guro-primary); color: #fff; padding: 4px 16px; border-radius: 20px; font-size: 12px; font-weight: 700;">MOST POPULAR</span>
                        <h4 class="mb-10">Professional</h4>
                        <div class="mb-20">
                            <span style="font-size: 40px; font-weight: 800; color: var(--guro-primary);">&euro;20</span>
                            <span style="color: #999;">/month</span>
                        </div>
                        <p style="color: #666;" class="mb-30">For growing iGaming companies.</p>
                        <ul style="list-style: none; padding: 0; flex: 1;">
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>10 Active Job Postings</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Enhanced Company Profile</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>60 Days Listing</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Applicant Tracking</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>3 Featured Listings</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Analytics Dashboard</li>
                        </ul>
                        <a href="{{ route('register') }}" class="custom-btn text-center" style="display: block;">Start Hiring</a>
                    </div>
                </div>
                <!-- Enterprise -->
                <div class="col-lg-4 col-md-6">
                    <div class="p-5 h-100 d-flex flex-column" style="background: #fff; border-radius: 16px; border: 2px solid #eee; transition: all 0.3s;">
                        <h4 class="mb-10">Enterprise</h4>
                        <div class="mb-20">
                            <span style="font-size: 40px; font-weight: 800; color: var(--guro-text);">&euro;15</span>
                            <span style="color: #999;">/month</span>
                        </div>
                        <p style="color: #666;" class="mb-30">For large operators and studios.</p>
                        <ul style="list-style: none; padding: 0; flex: 1;">
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Unlimited Job Postings</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Premium Company Profile</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>90 Days Listing</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Advanced Applicant Tracking</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>All Featured Listings</li>
                            <li class="mb-15"><i class="bi bi-check-circle-fill me-2" style="color: var(--guro-primary);"></i>Priority Support + API Access</li>
                        </ul>
                        <a href="{{ route('contact') }}" class="custom-btn text-center" style="display: block; background: #fff; color: var(--guro-primary); border: 2px solid var(--guro-primary);">Contact Sales</a>
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
                        <h2>Ready to Find Your Next Star Player?</h2>
                        <p class="mb-30">Join hundreds of iGaming companies already hiring on GURO JOBS.</p>
                        <a href="{{ route('register') }}" class="custom-btn">Create Employer Account</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
