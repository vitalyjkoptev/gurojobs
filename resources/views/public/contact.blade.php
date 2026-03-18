@extends('layouts.app')

@section('title', 'Contact Us — GURO JOBS')
@section('description', 'Get in touch with GURO JOBS. Questions about job listings, employer accounts, or partnerships? We are here to help.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100 pb-60">
                        <h1 class="mb-30">Contact Us</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Map -->
    <div class="map mb-160 md-mb-80">
        <div class="container-fluid">
            <div class="mapouter">
                <div class="gmap_canvas">
                    <iframe width="1920" height="550" id="gmap_canvas" src="https://maps.google.com/maps?q=Malta%20iGaming&t=&z=10&ie=UTF8&iwloc=&output=embed"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- Get In Touch -->
    <section class="get-touch mb-160 md-mb-80">
        <div class="container">
            <div class="text-center mb-50">
                <h2 class="heading-2">Get In Touch</h2>
            </div>
            <div class="row px0 g-5 d-flex align-items-center justify-content-center">
                <div class="col-lg-4">
                    <div class="touch-1 d-flex align-items-center justify-content-center flex-column mt-40 mb-40">
                        <div class="top-touch d-flex align-items-center justify-content-center"><i class="bi bi-envelope-open"></i></div>
                        <div class="bottom-touch pt-30"><span>hello@gurojobs.com</span></div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="touch-2 d-flex align-items-center justify-content-center flex-column mt-40 mb-40">
                        <div class="top-touch d-flex align-items-center justify-content-center"><i class="bi bi-geo-alt"></i></div>
                        <div class="bottom-touch pt-30"><span>Malta | Cyprus | Gibraltar | Remote</span></div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="touch-3 d-flex align-items-center justify-content-center flex-column mt-40 mb-40">
                        <div class="top-touch d-flex align-items-center justify-content-center"><i class="bi bi-telegram"></i></div>
                        <div class="bottom-touch pt-30"><span>@gurojobs</span></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Form -->
    <section class="contact-form mb-160 md-mb-80">
        <div class="container">
            <div class="text-center">
                <h2 class="heading-2">Send Us a Message</h2>
            </div>

            @if(session('success'))
                <div class="alert alert-success mt-30">{{ session('success') }}</div>
            @endif

            <form action="{{ route('contact.submit') }}" method="POST">
                @csrf
                <div class="row pt-60 g-5">
                    <div class="col-lg-4">
                        <label class="form-label mb-10">Full Name</label>
                        <input type="text" name="name" class="form-control" placeholder="Your Name" required>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label mb-10">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
                    </div>
                    <div class="col-lg-4">
                        <label class="form-label mb-10">Company (optional)</label>
                        <input type="text" name="company" class="form-control" placeholder="Your Company">
                    </div>
                </div>
                <div class="row pt-40 g-5">
                    <div class="col-lg-6">
                        <label class="form-label mb-10">Subject</label>
                        <select name="subject" class="form-control" required>
                            <option value="">Select a topic...</option>
                            <option value="job-listing">Job Listing Question</option>
                            <option value="employer">Employer Account</option>
                            <option value="candidate">Candidate Support</option>
                            <option value="partnership">Partnership</option>
                            <option value="advertising">Advertising</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    <div class="col-lg-6">
                        <label class="form-label mb-10">Phone (optional)</label>
                        <input class="form-control" type="tel" name="phone" placeholder="+356 1234 5678">
                    </div>
                </div>
                <div class="row pt-40 g-5">
                    <div class="col">
                        <label class="form-label mb-10">Message</label>
                        <textarea class="form-control" name="message" placeholder="How can we help you?" rows="10" required></textarea>
                        <button class="custom-btn d-flex align-items-center justify-content-center mt-60" type="submit">Send Message</button>
                    </div>
                </div>
            </form>
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
                        <p class="mb-30">Join the largest iGaming talent community. Find your next career move today.</p>
                        <a href="{{ route('register') }}" class="custom-btn">Get Started</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
