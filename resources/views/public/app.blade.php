@extends('layouts.app')

@section('title', 'Download GURO JOBS App')
@section('description', 'Download the GURO JOBS mobile app for Android and iOS. Find and apply for jobs on the go.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center flex-column mt-240 md-mt-100">
                        <div style="font-size: 48px; font-weight: 800; color: var(--guro-primary); letter-spacing: -1px; margin-bottom: 10px;">GURO <span style="font-weight: 300; color: var(--guro-text);">JOBS</span></div>
                        <h1 class="mb-30">Download the App</h1>
                    </div>
                    <p style="max-width: 560px; margin: 0 auto; color: #666; font-size: 17px;">Your career in your pocket. Browse jobs, apply instantly, track applications — all from your phone.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Download Cards -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="row justify-content-center g-4">
                <!-- Android -->
                <div class="col-lg-5 col-md-6">
                    <div class="p-5 text-center h-100" style="background: #fff; border-radius: 16px; border: 2px solid #eee; transition: all 0.3s;">
                        <div style="width: 80px; height: 80px; background: rgba(61,220,132,0.12); border-radius: 20px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                            <i class="bi bi-android2" style="font-size: 36px; color: #3DDC84;"></i>
                        </div>
                        <h4 class="mb-10">Android</h4>
                        <p style="color: #666; font-size: 15px; margin-bottom: 24px;">Download APK directly. Works on Android 6.0 and above.</p>
                        <a href="/downloads/GuroJobs.apk" class="custom-btn d-inline-block" style="background: #3DDC84; border-color: #3DDC84; padding: 12px 36px;">
                            <i class="bi bi-download me-2"></i>Download APK
                        </a>
                        <p class="mt-15" style="font-size: 12px; color: #999;">v1.0.0</p>
                    </div>
                </div>
                <!-- iOS -->
                <div class="col-lg-5 col-md-6">
                    <div class="p-5 text-center h-100" style="background: #fff; border-radius: 16px; border: 2px solid #eee; transition: all 0.3s;">
                        <div style="width: 80px; height: 80px; background: rgba(51,51,51,0.08); border-radius: 20px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                            <i class="bi bi-apple" style="font-size: 36px; color: #333;"></i>
                        </div>
                        <h4 class="mb-10">iOS</h4>
                        <p style="color: #666; font-size: 15px; margin-bottom: 24px;">Coming soon to the App Store. Stay tuned!</p>
                        <span class="custom-btn d-inline-block" style="background: #E0E0E0; border-color: #E0E0E0; color: #999; padding: 12px 36px; cursor: default;">
                            Coming Soon
                        </span>
                        <p class="mt-15" style="font-size: 12px; color: #999;">Expected Q2 2026</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- App Features -->
    <section class="mb-160 md-mb-80" style="background: var(--guro-bg); padding: 80px 0;">
        <div class="container">
            <div class="text-center mb-60">
                <h2 class="heading-2">Why Use the <span style="color: var(--guro-primary);">App</span>?</h2>
            </div>
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="text-center p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 60px; height: 60px; background: rgba(1,94,167,0.1); border-radius: 14px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                            <i class="bi bi-search" style="font-size: 24px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Smart Search</h5>
                        <p style="color: #666; font-size: 14px; margin: 0;">Filter jobs by category, location, salary and experience level</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="text-center p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 60px; height: 60px; background: rgba(1,94,167,0.1); border-radius: 14px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                            <i class="bi bi-lightning" style="font-size: 24px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Quick Apply</h5>
                        <p style="color: #666; font-size: 14px; margin: 0;">Apply to jobs with one tap using your saved profile</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="text-center p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 60px; height: 60px; background: rgba(1,94,167,0.1); border-radius: 14px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                            <i class="bi bi-bar-chart" style="font-size: 24px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">Track Status</h5>
                        <p style="color: #666; font-size: 14px; margin: 0;">Monitor your applications and get real-time updates</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="text-center p-4 h-100" style="background: #fff; border-radius: 12px; border: 1px solid #eee;">
                        <div style="width: 60px; height: 60px; background: rgba(1,94,167,0.1); border-radius: 14px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                            <i class="bi bi-translate" style="font-size: 24px; color: var(--guro-primary);"></i>
                        </div>
                        <h5 class="mb-10">3 Languages</h5>
                        <p style="color: #666; font-size: 14px; margin: 0;">Available in English, Russian and Ukrainian</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- App Categories -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="text-center mb-60">
                <h2 class="heading-2">Browse Jobs by <span style="color: var(--guro-primary);">Category</span></h2>
                <p style="max-width: 500px; margin: 10px auto 0; color: #666;">All categories available in the app — synced with the website.</p>
            </div>
            @php
                $appCats = [
                    ['name'=>'Gambling','slug'=>'gambling','icon'=>'icon_gambling.png'],
                    ['name'=>'Betting','slug'=>'betting','icon'=>'icon_betting.png'],
                    ['name'=>'Crypto','slug'=>'crypto','icon'=>'icon_crypto.png'],
                    ['name'=>'Dating','slug'=>'dating','icon'=>'icon_dating.png'],
                    ['name'=>'E-Commerce','slug'=>'e-commerce','icon'=>'icon_ecommerce.png'],
                    ['name'=>'FinTech','slug'=>'fintech','icon'=>'icon_fintech.png'],
                    ['name'=>'Nutra','slug'=>'nutra','icon'=>'icon_nutra.png'],
                    ['name'=>'Other','slug'=>'other','icon'=>'icon_other.png'],
                ];
            @endphp
            <div class="row g-3 justify-content-center">
                @foreach($appCats as $ac)
                <div class="col-lg-3 col-md-4 col-6">
                    <a href="{{ route('jobs.index', ['category' => $ac['slug']]) }}" style="text-decoration: none;">
                        <div class="text-center p-4" style="background: #fff; border-radius: 12px; border: 1px solid #eee; transition: all 0.3s;">
                            <img src="{{ asset('images/categories/' . $ac['icon']) }}" alt="{{ $ac['name'] }}" style="width: 48px; height: 48px; display: block; margin: 0 auto 10px; filter: brightness(0) saturate(100%) invert(23%) sepia(89%) saturate(2068%) hue-rotate(192deg) brightness(91%) contrast(101%) drop-shadow(0 0 0.5px #015EA7);">
                            <h6 style="font-size: 14px; margin: 0; color: #333;">{{ $ac['name'] }}</h6>
                        </div>
                    </a>
                </div>
                @endforeach
            </div>
        </div>
    </section>

    <!-- Already Registered -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="text-center p-5" style="background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06);">
                <div style="width: 64px; height: 64px; background: rgba(1,94,167,0.1); border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                    <i class="bi bi-person-check" style="font-size: 28px; color: var(--guro-primary);"></i>
                </div>
                <h3 class="mb-10">Already have an account?</h3>
                <p style="color: #666; font-size: 16px; margin-bottom: 20px;">Sign in on the website or download the app and log in with your credentials.</p>
                <a href="{{ route('login') }}" class="custom-btn">Sign In</a>
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
                        <h2>Join Our Community</h2>
                        <p class="mb-30">Get job alerts and connect with professionals in Telegram.</p>
                        <a href="https://t.me/GuroJobs" target="_blank" rel="noopener" class="custom-btn" style="background: #fff; color: var(--guro-primary);">
                            <i class="bi bi-telegram me-2"></i>Join Telegram
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
