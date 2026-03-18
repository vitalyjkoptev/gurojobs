@extends('layouts.app')

@section('title', 'Privacy Policy — GURO JOBS')
@section('description', 'GURO JOBS Privacy Policy. Learn how we collect, use, and protect your personal data.')

@section('content')

    <!-- Banner -->
    <div class="about-us-banner">
        <div class="about-three-rapper position-relative">
            <img src="{{ asset('images/shape/shape-2.png') }}" alt="" class="shape shape-12">
            <img src="{{ asset('images/shape/shape-3.png') }}" alt="" class="shape shape-13">
            <div class="container">
                <div class="row d-flex align-items-center justify-content-center flex-column text-center">
                    <div class="d-flex align-items-center justify-content-center mt-240 md-mt-100 pb-60">
                        <h1 class="mb-30">Privacy Policy</h1>
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

                        <h3 class="mb-20">1. Introduction</h3>
                        <p class="mb-40">GURO JOBS ("we", "us", "our") operates the gurojobs.com website and mobile application. This Privacy Policy explains how we collect, use, disclose, and protect your personal data when you use our Service. We are committed to protecting your privacy in compliance with the General Data Protection Regulation (GDPR) and applicable data protection laws.</p>

                        <h3 class="mb-20">2. Data We Collect</h3>
                        <p class="mb-20"><strong>Information you provide:</strong></p>
                        <ul class="mb-20" style="padding-left: 20px; line-height: 2;">
                            <li>Account data: name, email address, password (encrypted), role selection</li>
                            <li>Profile data: resume, skills, experience, education, salary expectations, bio</li>
                            <li>Company data (Employers): company name, description, website, location</li>
                            <li>Communication data: messages, contact form submissions, support requests</li>
                            <li>Payment data: processed by third-party providers (Stripe) — we do not store card numbers</li>
                        </ul>
                        <p class="mb-20"><strong>Information collected automatically:</strong></p>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li>Device information: browser type, operating system, device type</li>
                            <li>Usage data: pages visited, search queries, job views, click patterns</li>
                            <li>IP address and approximate geolocation</li>
                            <li>Cookies and similar tracking technologies</li>
                        </ul>

                        <h3 class="mb-20">3. How We Use Your Data</h3>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li>Provide and maintain the Service</li>
                            <li>Match candidates with relevant job opportunities</li>
                            <li>Enable employers to find and contact suitable candidates</li>
                            <li>Process payments and manage subscriptions</li>
                            <li>Send notifications about job applications, messages, and account updates</li>
                            <li>Improve the Service through analytics and usage patterns</li>
                            <li>Ensure security and prevent fraud</li>
                            <li>Comply with legal obligations</li>
                        </ul>

                        <h3 class="mb-20">4. Legal Basis for Processing (GDPR)</h3>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li><strong>Contractual necessity:</strong> Processing required to provide the Service to you</li>
                            <li><strong>Legitimate interest:</strong> Service improvement, security, fraud prevention</li>
                            <li><strong>Consent:</strong> Marketing communications, cookies, data sharing with employers</li>
                            <li><strong>Legal obligation:</strong> Compliance with applicable laws and regulations</li>
                        </ul>

                        <h3 class="mb-20">5. Data Sharing</h3>
                        <p class="mb-20">We may share your data with:</p>
                        <ul class="mb-20" style="padding-left: 20px; line-height: 2;">
                            <li><strong>Employers:</strong> When you apply for a job, your profile and resume are shared with the employer</li>
                            <li><strong>Service providers:</strong> Payment processors (Stripe), hosting providers, analytics tools</li>
                            <li><strong>Legal authorities:</strong> When required by law or to protect our rights</li>
                        </ul>
                        <p class="mb-40">We do NOT sell your personal data to third parties.</p>

                        <h3 class="mb-20">6. Data Retention</h3>
                        <p class="mb-40">We retain your personal data for as long as your account is active or as needed to provide services. When you delete your account, we will delete or anonymize your personal data within 30 days, except where retention is required by law or for legitimate business purposes (such as resolving disputes).</p>

                        <h3 class="mb-20">7. Your Rights (GDPR)</h3>
                        <p class="mb-20">Under GDPR, you have the right to:</p>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li><strong>Access:</strong> Request a copy of your personal data</li>
                            <li><strong>Rectification:</strong> Correct inaccurate or incomplete data</li>
                            <li><strong>Erasure:</strong> Request deletion of your personal data ("right to be forgotten")</li>
                            <li><strong>Portability:</strong> Receive your data in a machine-readable format</li>
                            <li><strong>Restriction:</strong> Request limitation of data processing</li>
                            <li><strong>Objection:</strong> Object to processing based on legitimate interests</li>
                            <li><strong>Withdraw consent:</strong> Withdraw previously given consent at any time</li>
                        </ul>

                        <h3 class="mb-20">8. Cookies</h3>
                        <p class="mb-20">GURO JOBS uses cookies for:</p>
                        <ul class="mb-40" style="padding-left: 20px; line-height: 2;">
                            <li><strong>Essential cookies:</strong> Required for the Service to function (session, CSRF protection)</li>
                            <li><strong>Analytics cookies:</strong> Help us understand how users interact with the Service</li>
                            <li><strong>Preference cookies:</strong> Remember your settings and preferences</li>
                        </ul>

                        <h3 class="mb-20">9. Data Security</h3>
                        <p class="mb-40">We implement industry-standard security measures to protect your data, including encryption (TLS/SSL), secure password hashing (bcrypt), access controls, and regular security audits. However, no method of electronic storage is 100% secure, and we cannot guarantee absolute security.</p>

                        <h3 class="mb-20">10. International Transfers</h3>
                        <p class="mb-40">Your data may be processed in the European Union (Malta, Cyprus) and other locations where our service providers operate. We ensure appropriate safeguards are in place for international data transfers in compliance with GDPR.</p>

                        <h3 class="mb-20">11. Children's Privacy</h3>
                        <p class="mb-40">GURO JOBS is not intended for individuals under 18 years of age. We do not knowingly collect personal data from children. If you believe we have collected data from a minor, please contact us immediately.</p>

                        <h3 class="mb-20">12. Changes to This Policy</h3>
                        <p class="mb-40">We may update this Privacy Policy from time to time. We will notify you of significant changes via email or a prominent notice on the Service. Your continued use of the Service after changes constitutes acceptance of the updated policy.</p>

                        <h3 class="mb-20">13. Contact</h3>
                        <p class="mb-40">For privacy-related questions or to exercise your rights, contact us at:<br>
                        <strong>Email:</strong> hello@gurojobs.com<br>
                        <strong>Telegram:</strong> @gurojobs</p>

                    </div>
                </div>
            </div>
        </div>
    </section>

@endsection
