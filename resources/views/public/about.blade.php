@extends('layouts.app')

@section('title', 'About Us — GURO JOBS')
@section('description', 'GURO JOBS is the leading iGaming job portal connecting top talent with the best companies in Casino, Betting, eSports and Game Development.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner mb-160 md-mb-100">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100">
                        <h1 class="mb-30">The #1 Job Portal for iGaming Professionals</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- How It Works -->
    <section class="dream-job2 mb-160 md-mb-80">
        <div class="container">
            <div class="text-center dream-heading">
                <span class="span-two">How It Works</span>
                <h3 class="heading-text3 mt-20 mb-60">Easy Steps To Get Your <span class="span-color">Dream iGaming Job</span></h3>
            </div>
            <div class="dremjob-content">
                <div class="row d-flex align-items-center justify-content-between g-5">
                    <div class="col-lg-4">
                        <div class="dreamitem-1">
                            <div class="dream-icon mb-30">
                                <i class="bi bi-person-plus"></i>
                            </div>
                            <a href="{{ route('register') }}"><span>Create Your Profile</span></a>
                        </div>
                    </div>
                    <div class="col-lg-4 ms-auto">
                        <div class="dreamitem-1">
                            <div class="dream-icon mb-30">
                                <i class="bi bi-file-earmark-text"></i>
                            </div>
                            <a href="{{ route('jobs.index') }}"><span>Browse iGaming Jobs</span></a>
                        </div>
                    </div>
                    <div class="col-lg-4 ms-auto">
                        <div class="dreamitem-1">
                            <div class="dream-icon mb-30">
                                <i class="bi bi-file-text"></i>
                            </div>
                            <a href="{{ route('jobs.index') }}"><span>Apply & Get Hired</span></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Us -->
    <section class="about-us mb-160 md-mb-80">
        <div class="container">
            <div class="about-us-rapper position-relative">
                <img src="{{ asset('images/shape/shape-5.png') }}" alt="" class="shape shape-5">
                <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-6">
                <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-7">
                <div class="row d-flex align-items-center">
                    <div class="col-lg-6 col-xl-6">
                        <div class="left-about left-about-us position-relative">
                            <img src="{{ asset('images/banner/banner-14.png') }}" alt="">
                            <img src="{{ asset('images/banner/banner-13.png') }}" alt="">
                            <img src="{{ asset('images/screen/screen-14.png') }}" alt="">
                            <img src="{{ asset('images/screen/screen-24.png') }}" alt="">
                            <img src="{{ asset('images/screen/screen-9.png') }}" alt="">
                        </div>
                    </div>
                    <div class="col-lg-5 col-xl-5 offset-lg-1 offset-xl-1 md-mt-80">
                        <div class="right-about-two">
                            <span class="span-two">About Us</span>
                            <h2 class="heading-2 mt-20 mb-30">Find Your Perfect iGaming Career</h2>
                            <p>GURO JOBS was built with a single mission — to connect top professionals with the best companies in Casino, Betting, eSports, Poker, and Game Development industries worldwide.</p>
                            <p class="mt-20 mb-30">Our platform serves thousands of professionals across Malta, Cyprus, Gibraltar, Isle of Man, and remote positions globally.</p>
                            <a href="{{ route('jobs.index') }}">Explore Jobs</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics -->
    <div class="staticties mb-160 md-mb-80">
        <div class="container">
            <div class="row d-flex align-items-center pt-80 pb-80">
                <div class="col-lg-3">
                    <div class="statistics-1 d-flex align-items-center flex-column">
                        <div class="top"><span class="counter">500</span>+</div>
                        <div class="bottom"><span>Active Jobs</span></div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="statistics-1 d-flex align-items-center flex-column">
                        <div class="top"><span class="counter">200</span>+</div>
                        <div class="bottom"><span>iGaming Companies</span></div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="statistics-1 d-flex align-items-center flex-column">
                        <div class="top"><span class="counter">10</span>K+</div>
                        <div class="bottom"><span>Registered Professionals</span></div>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="statistics-1 d-flex align-items-center flex-column">
                        <div class="top"><span class="counter">28</span>+</div>
                        <div class="bottom"><span>Job Categories</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Why Choose Us -->
    <section class="why-choose-us why-choose-us-three pb-160 md-pb-80">
        <div class="why-choose-us-rapper">
            <div class="container">
                <div class="choose-us-content position-relative mt-80">
                    <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-5">
                    <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-6">
                    <img src="{{ asset('images/shape/shape-6.png') }}" alt="" class="shape shape-7">
                    <div class="row g-5 align-items-center">
                        <div class="col-xl-5 left-choose-content">
                            <div class="choose-us-heading md-pb-80">
                                <span class="span-two">Why Choose Us</span>
                                <h2 class="text-justify mt-20 mb-30"><span>GURO JOBS</span> — Your Gateway to iGaming Careers</h2>
                                <div>
                                    <button class="item1" data-bs-toggle="collapse" data-bs-target="#collapse1" aria-expanded="false" aria-controls="collapse1">01. Industry-Specific Platform</button>
                                    <div class="collapse" id="collapse1">
                                        We focus exclusively on iGaming — Casino, Betting, eSports, Poker, Lottery, and Game Development. Every job listing is relevant to your career path.
                                    </div>
                                    <button class="item1" data-bs-toggle="collapse" data-bs-target="#collapse2" aria-expanded="false" aria-controls="collapse2">02. Global Reach & Remote Jobs</button>
                                    <div class="collapse" id="collapse2">
                                        Find positions in Malta, Cyprus, Gibraltar, Isle of Man, Curacao and remote roles worldwide. The iGaming industry knows no borders.
                                    </div>
                                    <button class="item1" data-bs-toggle="collapse" data-bs-target="#collapse3" aria-expanded="false" aria-controls="collapse3">03. Verified Employers Only</button>
                                    <div class="collapse" id="collapse3">
                                        Every company on GURO JOBS is verified. We work only with licensed operators, studios, affiliates, and trusted service providers.
                                    </div>
                                </div>
                                <a href="{{ route('register') }}" class="custom-btn custom-2-btn">Get Started</a>
                            </div>
                        </div>
                        <div class="col-xl-7 right-choose-content-three">
                            <img src="{{ asset('images/banner/banner-16.jpg') }}" alt="" class="ms-auto">
                            <img src="{{ asset('images/banner/banner-15.jpg') }}" alt="" class="ms-auto">
                            <img src="{{ asset('images/screen/screen-24.png') }}" alt="" class="ms-auto">
                            <img src="{{ asset('images/screen/screen-4.png') }}" alt="" class="ms-auto">
                            <img src="{{ asset('images/screen/screen-5.png') }}" alt="" class="ms-auto">
                            <img src="{{ asset('images/screen/screen-10.png') }}" alt="" class="ms-auto">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="testimonial mt-160 mb-160 md-mt-80 md-mb-80">
        <div class="container-fluid">
            <div class="testimonial-rapper-three">
                <div class="heding-center text-center">
                    <span class="span-two">Testimonial</span>
                    <h2 class="heading-2 mt-20">What Our Users Say</h2>
                </div>
                <div class="testimonial-content-Three pt-80">
                    <div class="container">
                        <div class="testimonial-slider-Three" id="testimonial_slider-three">
                            <div class="testimonial_item">
                                <div class="row">
                                    <div class="col">
                                        <div class="item-rapper d-flex flex-column align-items-start justify-content-center">
                                            <div class="item1 mb-30"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                                            <div class="item2 mb-30"><p>GURO JOBS helped me land my dream role as a Casino Product Manager in Malta. The platform is incredibly focused on iGaming.</p></div>
                                            <div class="item3 d-flex align-items-center">
                                                <div class="left-side">
                                                    <img src="{{ asset('images/team/team-4.jpg') }}" alt="">
                                                </div>
                                                <div class="right-side d-flex flex-column align-items-start">
                                                    <h5 class="mb-20">Alex M.</h5>
                                                    <span>Casino Product Manager</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="testimonial_item">
                                <div class="row">
                                    <div class="col">
                                        <div class="item-rapper d-flex flex-column align-items-start justify-content-center">
                                            <div class="item1 mb-30"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                                            <div class="item2 mb-30"><p>As a Sportsbook Operator, I found qualified candidates within 48 hours of posting. The best iGaming recruitment platform by far.</p></div>
                                            <div class="item3 d-flex align-items-center">
                                                <div class="left-side">
                                                    <img src="{{ asset('images/team/team-5.jpg') }}" alt="">
                                                </div>
                                                <div class="right-side d-flex flex-column align-items-start">
                                                    <h5 class="mb-20">Sarah K.</h5>
                                                    <span>HR Director, Betting Company</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="testimonial_item">
                                <div class="row">
                                    <div class="col">
                                        <div class="item-rapper d-flex flex-column align-items-start justify-content-center">
                                            <div class="item1 mb-30"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                                            <div class="item2 mb-30"><p>Switched from a generic job board to GURO JOBS and got 3x more relevant applications for our Slot Game Developer positions.</p></div>
                                            <div class="item3 d-flex align-items-center">
                                                <div class="left-side">
                                                    <img src="{{ asset('images/team/team-6.jpg') }}" alt="">
                                                </div>
                                                <div class="right-side d-flex flex-column align-items-start">
                                                    <h5 class="mb-20">Marco R.</h5>
                                                    <span>CTO, Game Studio</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="testimonial_item">
                                <div class="row">
                                    <div class="col">
                                        <div class="item-rapper d-flex flex-column align-items-start justify-content-center">
                                            <div class="item1 mb-30"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                                            <div class="item2 mb-30"><p>The CV Builder feature is excellent. It helped me create a professional iGaming resume that stands out to recruiters.</p></div>
                                            <div class="item3 d-flex align-items-center">
                                                <div class="left-side">
                                                    <img src="{{ asset('images/team/team-4.jpg') }}" alt="">
                                                </div>
                                                <div class="right-side d-flex flex-column align-items-start">
                                                    <h5 class="mb-20">Elena T.</h5>
                                                    <span>Compliance Analyst</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
                        <h2>10K+ iGaming Professionals Trust GURO JOBS</h2>
                        <p class="mb-30">Join the largest iGaming talent community. Create your profile and start applying today.</p>
                        <a href="{{ route('register') }}" class="custom-btn">Get Started</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
