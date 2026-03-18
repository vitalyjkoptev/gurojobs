@extends('layouts.app')

@section('title', 'Terms of Service — GURO JOBS')
@section('description', 'GURO JOBS Terms of Service. Read our terms and conditions for using the iGaming job portal.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100 pb-60">
                        <h1 class="mb-30">Terms of Service</h1>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Content -->
    <section class="mb-160 md-mb-80">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="legal-content pt-60">

                        <p style="color: #999; margin-bottom: 40px;">Last updated: {{ date('F d, Y') }}</p>

                        <h3 class="mb-20">1. Acceptance of Terms</h3>
                        <p class="mb-40">By accessing or using the GURO JOBS platform ("Service"), including our website and mobile application, you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, you may not use the Service. GURO JOBS reserves the right to modify these Terms at any time. Continued use of the Service after any changes constitutes acceptance of the updated Terms.</p>

                        <h3 class="mb-20">2. Eligibility</h3>
                        <p class="mb-40">You must be at least 18 years of age to use GURO JOBS. By creating an account, you represent and warrant that you are of legal age and have the legal capacity to enter into these Terms. Users who are banned or suspended may not create new accounts without prior written consent from GURO JOBS.</p>

                        <h3 class="mb-20">3. Account Registration</h3>
                        <p class="mb-20">When registering for an account, you agree to:</p>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li>Provide accurate, current, and complete information</li>
                            <li>Maintain and update your information to keep it accurate</li>
                            <li>Maintain the security of your account credentials</li>
                            <li>Accept responsibility for all activities under your account</li>
                            <li>Notify GURO JOBS immediately of any unauthorized use</li>
                        </ul>

                        <h3 class="mb-20">4. User Types</h3>
                        <p class="mb-20"><strong>Candidates</strong> may create profiles, upload resumes, apply for positions, and receive communications from Employers through the platform.</p>
                        <p class="mb-40"><strong>Employers</strong> may post job listings, review candidate applications, and manage company profiles. Employers are responsible for the accuracy and legality of their job postings, including compliance with applicable labor laws and non-discrimination regulations.</p>

                        <h3 class="mb-20">5. Prohibited Conduct</h3>
                        <p class="mb-20">You agree NOT to:</p>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li>Post false, misleading, or fraudulent job listings or profile information</li>
                            <li>Use the Service for any unlawful purpose or in violation of applicable regulations</li>
                            <li>Scrape, harvest, or collect data from GURO JOBS without authorization</li>
                            <li>Impersonate another person or entity</li>
                            <li>Transmit spam, malware, or unsolicited communications</li>
                            <li>Interfere with or disrupt the Service or its infrastructure</li>
                            <li>Circumvent security features, rate limits, or access controls</li>
                            <li>Use automated bots or scripts to access the Service without written approval</li>
                            <li>Post job listings requiring candidates to pay fees</li>
                            <li>Discriminate against candidates on the basis of race, gender, religion, nationality, disability, or any other protected characteristic</li>
                        </ul>

                        <h3 class="mb-20">6. Content & Intellectual Property</h3>
                        <p class="mb-20">You retain ownership of content you submit to GURO JOBS (resumes, job listings, profiles). However, by submitting content, you grant GURO JOBS a non-exclusive, worldwide, royalty-free license to use, display, reproduce, and distribute your content in connection with operating the Service.</p>
                        <p class="mb-40">GURO JOBS retains all rights to its platform, branding, design, code, and proprietary technology. You may not copy, modify, distribute, or create derivative works from any GURO JOBS materials without written permission.</p>

                        <h3 class="mb-20">7. Payment & Subscriptions</h3>
                        <p class="mb-40">Certain features require paid subscriptions. All payments are processed through third-party providers (Stripe, cryptocurrency). Subscription fees are non-refundable unless otherwise required by applicable law. GURO JOBS reserves the right to change pricing with 30 days' notice. Failure to pay may result in downgrade or suspension of services.</p>

                        <h3 class="mb-20">8. Limitation of Liability</h3>
                        <p class="mb-20">GURO JOBS provides the Service "AS IS" and "AS AVAILABLE." We do not guarantee:</p>
                        <ul class="mb-20" style="padding-left: 20px; line-height: 2;">
                            <li>That any job application will result in employment</li>
                            <li>The accuracy or reliability of user-submitted content</li>
                            <li>Uninterrupted or error-free operation of the Service</li>
                            <li>The quality, legality, or safety of any job listing or employer</li>
                        </ul>
                        <p class="mb-40">To the maximum extent permitted by law, GURO JOBS, its officers, directors, employees, and agents shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or business opportunities, arising from or related to your use of the Service.</p>

                        <h3 class="mb-20">9. Indemnification</h3>
                        <p class="mb-40">You agree to indemnify and hold harmless GURO JOBS, its affiliates, officers, directors, employees, and agents from any claims, liabilities, damages, losses, or expenses (including legal fees) arising from your use of the Service, your violation of these Terms, or your violation of any third-party rights.</p>

                        <h3 class="mb-20">10. Termination</h3>
                        <p class="mb-40">GURO JOBS reserves the right to suspend or terminate your account at any time, with or without cause, with or without notice. Upon termination, your right to use the Service ceases immediately. Sections regarding intellectual property, liability, indemnification, and governing law shall survive termination.</p>

                        <h3 class="mb-20">11. Dispute Resolution</h3>
                        <p class="mb-40">Any disputes arising from these Terms or the Service shall be resolved through binding arbitration in accordance with the rules of the Malta Arbitration Centre. The governing law shall be the laws of Malta. You agree to resolve disputes individually and waive any right to class action proceedings.</p>

                        <h3 class="mb-20">12. Governing Law</h3>
                        <p class="mb-40">These Terms shall be governed by and construed in accordance with the laws of Malta, without regard to conflict of law principles. The courts of Malta shall have exclusive jurisdiction over any legal proceedings arising from these Terms.</p>

                        <h3 class="mb-20">13. Contact</h3>
                        <p class="mb-40">For questions about these Terms, contact us at:<br>
                        <strong>Email:</strong> hello@gurojobs.com<br>
                        <strong>Telegram:</strong> @gurojobs</p>

                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
