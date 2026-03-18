@extends('admin.partials.layouts.master')

@section('title', 'FAQs — GURO JOBS Admin')
@section('pagetitle', 'Pages')
@section('sub-title', 'FAQs')

@section('content')

<div class="card mb-4">
    <div class="card-body">
        <div class="row justify-content-center mb-4">
            <div class="col-xl-7">
                <div class="py-2">
                    <div class="text-center">
                        <h3 class="text-primary mb-3">FAQs</h3>
                        <h5 class="d-block">Need help? Here are some commonly asked questions!</h5>
                        <p class="text-muted mb-2 px-4">Find answers to common questions about job postings, subscriptions, payments, and using the GURO JOBS platform.</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="bg-body p-2 rounded-3">
            <div class="d-flex justify-content-between align-items-center gap-2 flex-wrap">
                <ul class="nav nav-pills" role="tablist">
                    <li class="nav-item" role="presentation">
                        <a class="nav-link py-1 active" data-bs-toggle="tab" href="#faq-general" role="tab" aria-selected="true">General</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link py-1" data-bs-toggle="tab" href="#faq-employers" role="tab" aria-selected="false">For Employers</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link py-1" data-bs-toggle="tab" href="#faq-candidates" role="tab" aria-selected="false">For Candidates</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link py-1" data-bs-toggle="tab" href="#faq-billing" role="tab" aria-selected="false">Billing</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="tab-content">
    <!-- General -->
    <div class="tab-pane active show" id="faq-general" role="tabpanel">
        <div class="row g-2">
            <div class="col-lg-9">
                <div class="card">
                    <div class="card-body">
                        <h6 class="h6 mb-4">General Questions</h6>
                        <div class="accordion accordion-light accordion-border-box" id="faq_general_accordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq_g1" aria-expanded="true">
                                        What is GURO JOBS?
                                    </button>
                                </h2>
                                <div id="faq_g1" class="accordion-collapse collapse show" data-bs-parent="#faq_general_accordion">
                                    <div class="accordion-body">
                                        GURO JOBS is a specialized job platform for the iGaming industry. We connect top talent with leading casino, sports betting, eSports, and game development companies worldwide.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_g2" aria-expanded="false">
                                        What experience levels are supported?
                                    </button>
                                </h2>
                                <div id="faq_g2" class="accordion-collapse collapse" data-bs-parent="#faq_general_accordion">
                                    <div class="accordion-body">
                                        We support all experience levels: C-Level executives, Head of Department, Senior, Middle, Junior, and Intern positions across all iGaming disciplines.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_g3" aria-expanded="false">
                                        What job categories are available?
                                    </button>
                                </h2>
                                <div id="faq_g3" class="accordion-collapse collapse" data-bs-parent="#faq_general_accordion">
                                    <div class="accordion-body">
                                        We cover Casino Operations, Sports Betting, Poker, eSports, Lottery & Bingo, Game Development, Platform & Backend, Payments & Risk, Compliance & Legal, Marketing & Affiliates, Customer Support, HR & Recruitment, and more.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_g4" aria-expanded="false">
                                        Is there a mobile app?
                                    </button>
                                </h2>
                                <div id="faq_g4" class="accordion-collapse collapse" data-bs-parent="#faq_general_accordion">
                                    <div class="accordion-body">
                                        Yes! GURO JOBS has a Flutter-based mobile app available for both iOS and Android. You can search jobs, apply, manage your profile, and receive push notifications for new matching positions.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_g5" aria-expanded="false">
                                        Which regions do you cover?
                                    </button>
                                </h2>
                                <div id="faq_g5" class="accordion-collapse collapse" data-bs-parent="#faq_general_accordion">
                                    <div class="accordion-body">
                                        We cover all major iGaming hubs: Malta, Cyprus, Gibraltar, Isle of Man, Curacao, as well as Remote, Europe-wide, Asia, and LATAM positions.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="card">
                    <div class="card-body">
                        <h5 class="fw-semibold mb-3">Quick Links</h5>
                        <ul class="list-group email-label list-group-flush">
                            <li class="list-group-item border-0 p-0 pb-3 d-flex align-items-center gap-2">
                                <span class="d-inline-block rounded-pill bg-primary-subtle w-8px h-8px"></span>
                                <a href="{{ route('admin.settings') }}" class="fw-medium text-truncate mb-0">Platform Settings</a>
                            </li>
                            <li class="list-group-item border-0 p-0 pb-3 d-flex align-items-center gap-2">
                                <span class="d-inline-block rounded-pill bg-success-subtle w-8px h-8px"></span>
                                <a href="{{ route('admin.categories') }}" class="fw-medium text-truncate mb-0">Job Categories</a>
                            </li>
                            <li class="list-group-item border-0 p-0 pb-3 d-flex align-items-center gap-2">
                                <span class="d-inline-block rounded-pill bg-warning-subtle w-8px h-8px"></span>
                                <a href="{{ route('admin.subscriptions') }}" class="fw-medium text-truncate mb-0">Pricing Plans</a>
                            </li>
                            <li class="list-group-item border-0 p-0 pb-3 d-flex align-items-center gap-2">
                                <span class="d-inline-block rounded-pill bg-info-subtle w-8px h-8px"></span>
                                <a href="{{ route('admin.payments') }}" class="fw-medium text-truncate mb-0">Payment Methods</a>
                            </li>
                            <li class="list-group-item border-0 p-0 d-flex align-items-center gap-2">
                                <span class="d-inline-block rounded-pill bg-danger-subtle w-8px h-8px"></span>
                                <a href="{{ route('admin.users') }}" class="fw-medium text-truncate mb-0">User Management</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body text-center">
                        <i class="ri-customer-service-2-line display-4 text-primary mb-3"></i>
                        <h6>Need More Help?</h6>
                        <p class="text-muted fs-13">Contact our support team</p>
                        <a href="mailto:support@gurojobs.com" class="btn btn-primary btn-sm">Contact Support</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- For Employers -->
    <div class="tab-pane" id="faq-employers" role="tabpanel">
        <div class="card">
            <div class="card-body">
                <h6 class="h6 mb-4">Questions for Employers</h6>
                <div class="accordion accordion-light accordion-border-box" id="faq_employers_accordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_e1">How do I post a job?</button>
                        </h2>
                        <div id="faq_e1" class="accordion-collapse collapse" data-bs-parent="#faq_employers_accordion">
                            <div class="accordion-body">Register as an employer, create your company profile, and click "Post a Job". Fill in the job details including title, description, requirements, salary range, location, and experience level. Jobs are reviewed and published within 24 hours.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_e2">What are the subscription plans?</button>
                        </h2>
                        <div id="faq_e2" class="accordion-collapse collapse" data-bs-parent="#faq_employers_accordion">
                            <div class="accordion-body">We offer four plans: Free (1 job/month), Starter ($49/mo - 10 jobs), Business ($149/mo - 50 jobs), and Enterprise ($499/mo - Unlimited jobs). All paid plans include featured listings, analytics, and priority support.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_e3">Can I feature my job listing?</button>
                        </h2>
                        <div id="faq_e3" class="accordion-collapse collapse" data-bs-parent="#faq_employers_accordion">
                            <div class="accordion-body">Yes! Featured jobs appear at the top of search results and on the homepage. This option is available on all paid subscription plans.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_e4">How do I manage applications?</button>
                        </h2>
                        <div id="faq_e4" class="accordion-collapse collapse" data-bs-parent="#faq_employers_accordion">
                            <div class="accordion-body">All applications are available in your employer dashboard. You can review candidates, download resumes, change application status (pending, shortlisted, hired, rejected), and communicate with applicants directly.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_e5">What payment methods do you accept?</button>
                        </h2>
                        <div id="faq_e5" class="accordion-collapse collapse" data-bs-parent="#faq_employers_accordion">
                            <div class="accordion-body">We accept Stripe (credit/debit cards), Apple Pay, Google Pay, and cryptocurrency payments via NOWPayments. All transactions are secure and encrypted.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- For Candidates -->
    <div class="tab-pane" id="faq-candidates" role="tabpanel">
        <div class="card">
            <div class="card-body">
                <h6 class="h6 mb-4">Questions for Candidates</h6>
                <div class="accordion accordion-light accordion-border-box" id="faq_candidates_accordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_c1">Is it free to use as a candidate?</button>
                        </h2>
                        <div id="faq_c1" class="accordion-collapse collapse" data-bs-parent="#faq_candidates_accordion">
                            <div class="accordion-body">Yes! GURO JOBS is completely free for job seekers. You can create a profile, upload your resume, browse jobs, and apply to as many positions as you like at no cost.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_c2">How do I create a strong profile?</button>
                        </h2>
                        <div id="faq_c2" class="accordion-collapse collapse" data-bs-parent="#faq_candidates_accordion">
                            <div class="accordion-body">Complete all profile sections, upload a professional photo, add your skills and experience, and use our CV Builder to create an impressive iGaming-focused resume. Complete profiles get 3x more views from employers.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_c3">Can I get notifications for new jobs?</button>
                        </h2>
                        <div id="faq_c3" class="accordion-collapse collapse" data-bs-parent="#faq_candidates_accordion">
                            <div class="accordion-body">Yes! Set up job alerts based on your preferred categories, locations, and experience level. Get notified via email, push notification, or Telegram when matching jobs are posted.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_c4">Do you offer a CV Builder?</button>
                        </h2>
                        <div id="faq_c4" class="accordion-collapse collapse" data-bs-parent="#faq_candidates_accordion">
                            <div class="accordion-body">Yes! Our built-in CV Builder helps you create a professional iGaming resume with industry-specific templates, skill sections, and formatting optimized for ATS systems.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Billing -->
    <div class="tab-pane" id="faq-billing" role="tabpanel">
        <div class="card">
            <div class="card-body">
                <h6 class="h6 mb-4">Billing & Payments</h6>
                <div class="accordion accordion-light accordion-border-box" id="faq_billing_accordion">
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_b1">How does billing work?</button>
                        </h2>
                        <div id="faq_b1" class="accordion-collapse collapse" data-bs-parent="#faq_billing_accordion">
                            <div class="accordion-body">Subscriptions are billed monthly. You can upgrade, downgrade, or cancel at any time. Payments are processed securely through Stripe.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_b2">Can I pay with cryptocurrency?</button>
                        </h2>
                        <div id="faq_b2" class="accordion-collapse collapse" data-bs-parent="#faq_billing_accordion">
                            <div class="accordion-body">Yes! We accept cryptocurrency payments via NOWPayments. Bitcoin, Ethereum, USDT, and many other cryptocurrencies are supported.</div>
                        </div>
                    </div>
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq_b3">What is the refund policy?</button>
                        </h2>
                        <div id="faq_b3" class="accordion-collapse collapse" data-bs-parent="#faq_billing_accordion">
                            <div class="accordion-body">We offer a 14-day money-back guarantee on all subscription plans. If you're not satisfied, contact support for a full refund within 14 days of purchase.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
