<?php

namespace Database\Seeders;

use App\Models\Company;
use App\Models\Job;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DemoDataSeeder extends Seeder
{
    public function run(): void
    {
        // ── Demo Employers ──────────────────────────────────────
        $companies = [
            ['name' => 'BetVision Group', 'slug' => 'betvision-group', 'description' => 'Leading sports betting platform with 10M+ users worldwide', 'website' => 'https://betvision.com', 'location' => 'Malta', 'size' => '500-1000', 'verified' => true, 'rating_avg' => 4.5],
            ['name' => 'CasinoTech Solutions', 'slug' => 'casinotech-solutions', 'description' => 'B2B casino platform provider powering 200+ brands', 'website' => 'https://casinotech.io', 'location' => 'Cyprus', 'size' => '200-500', 'verified' => true, 'rating_avg' => 4.2],
            ['name' => 'LuckySlots Inc', 'slug' => 'luckyslots-inc', 'description' => 'Premium slot game developer with 150+ titles', 'website' => 'https://luckyslots.com', 'location' => 'Gibraltar', 'size' => '100-200', 'verified' => true, 'rating_avg' => 4.7],
            ['name' => 'PokerStars Europe', 'slug' => 'pokerstars-europe', 'description' => 'World\'s largest online poker platform', 'website' => 'https://pokerstars.eu', 'location' => 'Isle of Man', 'size' => '1000+', 'verified' => true, 'rating_avg' => 4.8],
            ['name' => 'AffiliateKings', 'slug' => 'affiliatekings', 'description' => 'Top CPA network for iGaming affiliates', 'website' => 'https://affiliatekings.com', 'location' => 'Malta', 'size' => '50-100', 'verified' => true, 'rating_avg' => 4.0],
            ['name' => 'PayGaming Solutions', 'slug' => 'paygaming-solutions', 'description' => 'Fintech payment provider specializing in iGaming transactions', 'website' => 'https://paygaming.com', 'location' => 'London, UK', 'size' => '100-200', 'verified' => true, 'rating_avg' => 4.3],
            ['name' => 'LiveDealer Pro', 'slug' => 'livedealer-pro', 'description' => 'Live casino streaming technology and dealer management', 'website' => 'https://livedealerpro.com', 'location' => 'Riga, Latvia', 'size' => '200-500', 'verified' => false, 'rating_avg' => 3.9],
            ['name' => 'OddsMatrix', 'slug' => 'oddsmatrix', 'description' => 'Real-time sports data and odds feed provider', 'website' => 'https://oddsmatrix.com', 'location' => 'Bucharest, Romania', 'size' => '50-100', 'verified' => true, 'rating_avg' => 4.1],
        ];

        $companyModels = [];
        foreach ($companies as $c) {
            $user = User::create([
                'name' => 'HR ' . $c['name'],
                'email' => 'hr@' . Str::slug($c['name']) . '.com',
                'password' => 'Demo2026guro',
                'role' => 'employer',
                'status' => 'active',
            ]);

            $c['user_id'] = $user->id;
            $companyModels[] = Company::create($c);

            $user->update(['company_id' => $companyModels[count($companyModels) - 1]->id]);
        }

        // ── Demo Jobs ───────────────────────────────────────────
        $jobs = [
            // C-Level
            ['title' => 'Chief Marketing Officer (CMO)', 'category_slug' => 'marketing-communications', 'experience_level' => 'c-level', 'company_idx' => 0, 'salary_min' => 180000, 'salary_max' => 250000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Malta', 'is_featured' => true, 'is_urgent' => false, 'description' => '<p>We are looking for an experienced CMO to lead our marketing strategy across 15+ markets. You will oversee brand positioning, user acquisition, retention campaigns, and manage a team of 40+ marketing professionals.</p><h4>Requirements:</h4><ul><li>10+ years in iGaming marketing leadership</li><li>Proven track record of scaling brands to 1M+ users</li><li>Deep understanding of affiliate marketing, SEO, PPC, and CRM</li><li>Experience with regulated markets (MGA, UKGC)</li></ul><h4>We offer:</h4><ul><li>Competitive salary + equity options</li><li>Relocation package to Malta</li><li>Annual bonus up to 30%</li></ul>', 'tags' => ['marketing', 'leadership', 'strategy', 'acquisition'], 'keywords' => ['CMO', 'Chief Marketing Officer', 'VP Marketing']],
            ['title' => 'Chief Technology Officer (CTO)', 'category_slug' => 'it-development', 'experience_level' => 'c-level', 'company_idx' => 1, 'salary_min' => 200000, 'salary_max' => 300000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Cyprus', 'is_featured' => true, 'is_urgent' => false, 'description' => '<p>Join CasinoTech as CTO to architect our next-gen casino platform. Lead 80+ engineers across backend, frontend, mobile, and DevOps teams.</p><h4>Requirements:</h4><ul><li>15+ years software engineering, 5+ in CTO/VP Engineering role</li><li>iGaming platform architecture experience</li><li>Microservices, Kubernetes, real-time systems expertise</li></ul>', 'tags' => ['technology', 'architecture', 'engineering', 'leadership'], 'keywords' => ['CTO', 'Chief Technology Officer', 'VP Engineering']],
            ['title' => 'Chief Revenue Officer (CRO)', 'category_slug' => 'c-level-executive', 'experience_level' => 'c-level', 'company_idx' => 3, 'salary_min' => 220000, 'salary_max' => 350000, 'job_type' => 'full-time', 'work_mode' => 'on-site', 'location' => 'Isle of Man', 'is_featured' => true, 'is_urgent' => true, 'description' => '<p>PokerStars is seeking a CRO to drive revenue growth across poker, casino, and sports verticals. Direct P&L responsibility for $2B+ annual revenue.</p>', 'tags' => ['revenue', 'growth', 'strategy'], 'keywords' => ['CRO', 'Chief Revenue Officer', 'Revenue Director']],

            // Head
            ['title' => 'Head of Affiliates', 'category_slug' => 'cpa-affiliate-networks', 'experience_level' => 'head', 'company_idx' => 4, 'salary_min' => 90000, 'salary_max' => 130000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote (EU)', 'is_featured' => true, 'is_urgent' => false, 'description' => '<p>Lead our affiliate program managing 2000+ partners. Build and optimize CPA, RevShare, and hybrid deals. Manage $5M+ monthly affiliate budget.</p><h4>Requirements:</h4><ul><li>7+ years in iGaming affiliate management</li><li>Strong network of affiliates and media buyers</li><li>Experience with HasOffers, Income Access, or similar</li></ul>', 'tags' => ['affiliates', 'CPA', 'partnerships', 'revenue'], 'keywords' => ['Head of Affiliates', 'Affiliate Director', 'Partnership Manager']],
            ['title' => 'Head of Game Studio', 'category_slug' => 'game-provider', 'experience_level' => 'head', 'company_idx' => 2, 'salary_min' => 100000, 'salary_max' => 150000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Gibraltar', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Lead our slot game development studio. Manage a team of 25 including game designers, mathematicians, artists, and developers.</p>', 'tags' => ['game studio', 'slots', 'management', 'creative'], 'keywords' => ['Head of Studio', 'Game Studio Director', 'Studio Lead']],
            ['title' => 'Head of Payments', 'category_slug' => 'psp-payment-solutions', 'experience_level' => 'head', 'company_idx' => 5, 'salary_min' => 95000, 'salary_max' => 140000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'London, UK', 'is_featured' => true, 'is_urgent' => true, 'description' => '<p>Oversee all payment operations: fiat, crypto, e-wallets. Integrate 50+ payment methods across 30+ markets. Manage PSP relationships and optimize conversion rates.</p>', 'tags' => ['payments', 'fintech', 'PSP', 'crypto'], 'keywords' => ['Head of Payments', 'Payment Director', 'Payment Operations']],

            // Senior
            ['title' => 'Senior Slot Game Developer', 'category_slug' => 'game-provider', 'experience_level' => 'senior', 'company_idx' => 2, 'salary_min' => 70000, 'salary_max' => 95000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Develop HTML5 slot games using PixiJS/Phaser. Work with game mathematicians to implement RNG mechanics, bonus features, and progressive jackpots.</p><h4>Requirements:</h4><ul><li>5+ years game development (HTML5/Canvas/WebGL)</li><li>Experience with slot game mechanics and math models</li><li>Strong TypeScript/JavaScript skills</li></ul>', 'tags' => ['slot development', 'HTML5', 'PixiJS', 'game dev'], 'keywords' => ['Slot Developer', 'Game Developer', 'HTML5 Developer']],
            ['title' => 'Senior Media Buyer', 'category_slug' => 'traffic-media-buying', 'experience_level' => 'senior', 'company_idx' => 0, 'salary_min' => 55000, 'salary_max' => 80000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote (EU)', 'is_featured' => false, 'is_urgent' => true, 'description' => '<p>Manage $500K+ monthly ad spend across Facebook, Google, TikTok, and programmatic channels. Focus on FTD (First Time Depositor) acquisition for sports betting vertical.</p>', 'tags' => ['media buying', 'PPC', 'Facebook Ads', 'user acquisition'], 'keywords' => ['Media Buyer', 'Performance Marketer', 'UA Manager']],
            ['title' => 'Senior Odds Compiler', 'category_slug' => 'sports-betting', 'experience_level' => 'senior', 'company_idx' => 7, 'salary_min' => 65000, 'salary_max' => 90000, 'job_type' => 'full-time', 'work_mode' => 'on-site', 'location' => 'Bucharest, Romania', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Compile and manage odds for football, tennis, and basketball. Use statistical models and real-time data to ensure competitive pricing with controlled margins.</p>', 'tags' => ['odds', 'trading', 'sports', 'analytics'], 'keywords' => ['Odds Compiler', 'Trading Analyst', 'Sportsbook Trader']],
            ['title' => 'Senior Compliance Officer', 'category_slug' => 'legal-compliance', 'experience_level' => 'senior', 'company_idx' => 3, 'salary_min' => 70000, 'salary_max' => 100000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Isle of Man', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Ensure compliance with MGA, UKGC, and 10+ other jurisdictions. Manage AML/KYC processes, responsible gambling policies, and regulatory reporting.</p>', 'tags' => ['compliance', 'AML', 'KYC', 'regulation'], 'keywords' => ['Compliance Officer', 'AML Officer', 'Regulatory Affairs']],
            ['title' => 'Senior Backend Developer (Go/Rust)', 'category_slug' => 'it-development', 'experience_level' => 'senior', 'company_idx' => 1, 'salary_min' => 75000, 'salary_max' => 110000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote', 'is_featured' => true, 'is_urgent' => false, 'description' => '<p>Build high-performance microservices handling 100K+ concurrent connections. Our platform processes 5M+ bets daily.</p><h4>Stack:</h4><ul><li>Go or Rust for core services</li><li>gRPC + Kafka for inter-service communication</li><li>PostgreSQL + Redis + ClickHouse</li><li>Kubernetes on AWS</li></ul>', 'tags' => ['Go', 'Rust', 'backend', 'microservices', 'high-load'], 'keywords' => ['Backend Developer', 'Go Developer', 'Rust Developer', 'Systems Engineer']],

            // Middle
            ['title' => 'Game Mathematician', 'category_slug' => 'game-provider', 'experience_level' => 'middle', 'company_idx' => 2, 'salary_min' => 45000, 'salary_max' => 65000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Gibraltar', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Design mathematical models for slot games — RTP calculations, volatility profiles, hit frequency optimization, bonus mechanics. Simulate millions of rounds to validate game balance.</p>', 'tags' => ['mathematics', 'statistics', 'RTP', 'game design'], 'keywords' => ['Game Mathematician', 'Probability Analyst', 'Game Designer']],
            ['title' => 'Frontend Developer (React)', 'category_slug' => 'it-development', 'experience_level' => 'middle', 'company_idx' => 0, 'salary_min' => 40000, 'salary_max' => 60000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Build responsive sportsbook UI with real-time odds updates, live betting interfaces, and bet slip functionality using React + TypeScript + WebSockets.</p>', 'tags' => ['React', 'TypeScript', 'frontend', 'WebSocket'], 'keywords' => ['Frontend Developer', 'React Developer', 'UI Developer']],
            ['title' => 'VIP Account Manager', 'category_slug' => 'customer-support', 'experience_level' => 'middle', 'company_idx' => 3, 'salary_min' => 40000, 'salary_max' => 55000, 'job_type' => 'full-time', 'work_mode' => 'on-site', 'location' => 'Malta', 'is_featured' => false, 'is_urgent' => true, 'description' => '<p>Manage portfolio of 200+ high-value players. Personalized engagement, exclusive promotions, event invitations, and retention strategies for VIP segment.</p>', 'tags' => ['VIP', 'retention', 'account management', 'CRM'], 'keywords' => ['VIP Manager', 'Account Manager', 'Player Manager']],
            ['title' => 'Live Casino Dealer Trainer', 'category_slug' => 'casino-operations', 'experience_level' => 'middle', 'company_idx' => 6, 'salary_min' => 30000, 'salary_max' => 42000, 'job_type' => 'full-time', 'work_mode' => 'on-site', 'location' => 'Riga, Latvia', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Train and certify live casino dealers for blackjack, roulette, baccarat, and game shows. Ensure quality standards and camera presentation skills.</p>', 'tags' => ['live casino', 'training', 'dealers', 'quality'], 'keywords' => ['Dealer Trainer', 'Casino Trainer', 'Live Casino Manager']],
            ['title' => 'QA Engineer (Sportsbook)', 'category_slug' => 'it-development', 'experience_level' => 'middle', 'company_idx' => 7, 'salary_min' => 35000, 'salary_max' => 50000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Bucharest, Romania', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Test sportsbook platform — odds accuracy, bet placement flows, settlement logic, live betting stability. Automate regression with Cypress + Playwright.</p>', 'tags' => ['QA', 'testing', 'automation', 'sportsbook'], 'keywords' => ['QA Engineer', 'Test Engineer', 'SDET']],

            // Junior
            ['title' => 'Junior Affiliate Manager', 'category_slug' => 'cpa-affiliate-networks', 'experience_level' => 'junior', 'company_idx' => 4, 'salary_min' => 25000, 'salary_max' => 35000, 'job_type' => 'full-time', 'work_mode' => 'on-site', 'location' => 'Malta', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Support senior affiliate managers in partner onboarding, tracking setup, reporting, and communication. Great entry point into iGaming affiliate marketing.</p>', 'tags' => ['affiliates', 'entry-level', 'partnerships'], 'keywords' => ['Junior Affiliate', 'Affiliate Coordinator', 'Partner Associate']],
            ['title' => 'Junior Game Artist (2D/3D)', 'category_slug' => 'game-provider', 'experience_level' => 'junior', 'company_idx' => 2, 'salary_min' => 28000, 'salary_max' => 38000, 'job_type' => 'full-time', 'work_mode' => 'hybrid', 'location' => 'Gibraltar', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Create stunning slot game visuals — symbols, backgrounds, animations, UI elements. Work with Spine, Adobe Suite, Blender.</p>', 'tags' => ['2D art', '3D art', 'game art', 'animation'], 'keywords' => ['Game Artist', '2D Artist', 'Slot Designer']],
            ['title' => 'Customer Support Agent (English/German)', 'category_slug' => 'customer-support', 'experience_level' => 'junior', 'company_idx' => 0, 'salary_min' => 22000, 'salary_max' => 30000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote (EU)', 'is_featured' => false, 'is_urgent' => true, 'description' => '<p>Provide top-quality support via live chat and email. Handle player inquiries about deposits, withdrawals, bonuses, and account verification.</p>', 'tags' => ['support', 'live chat', 'multilingual'], 'keywords' => ['Support Agent', 'Customer Service', 'Player Support']],
            ['title' => 'Junior DevOps Engineer', 'category_slug' => 'it-development', 'experience_level' => 'junior', 'company_idx' => 1, 'salary_min' => 30000, 'salary_max' => 42000, 'job_type' => 'full-time', 'work_mode' => 'remote', 'location' => 'Remote', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Help maintain CI/CD pipelines, Kubernetes clusters, and monitoring infrastructure. Learn from our senior DevOps team while supporting 200+ microservices.</p>', 'tags' => ['DevOps', 'Kubernetes', 'CI/CD', 'AWS'], 'keywords' => ['DevOps Engineer', 'SRE', 'Infrastructure Engineer']],

            // Contract / Freelance
            ['title' => 'Freelance SEO Specialist (iGaming)', 'category_slug' => 'seo-content', 'experience_level' => 'senior', 'company_idx' => 4, 'salary_min' => 5000, 'salary_max' => 8000, 'job_type' => 'freelance', 'work_mode' => 'remote', 'location' => 'Remote', 'is_featured' => false, 'is_urgent' => false, 'description' => '<p>Monthly retainer for iGaming SEO. Manage organic strategy for 5 casino review sites. Link building, technical SEO, content strategy.</p>', 'tags' => ['SEO', 'content', 'link building', 'organic'], 'keywords' => ['SEO Specialist', 'SEO Manager', 'Organic Growth']],
            ['title' => 'Contract Blockchain Developer', 'category_slug' => 'it-development', 'experience_level' => 'senior', 'company_idx' => 5, 'salary_min' => 8000, 'salary_max' => 15000, 'job_type' => 'contract', 'work_mode' => 'remote', 'location' => 'Remote', 'is_featured' => false, 'is_urgent' => true, 'description' => '<p>6-month contract to build crypto payment gateway. Integrate Bitcoin, Ethereum, USDT, and USDC. Smart contract development for provably fair gaming.</p>', 'tags' => ['blockchain', 'crypto', 'smart contracts', 'Solidity'], 'keywords' => ['Blockchain Developer', 'Web3 Developer', 'Smart Contract Developer']],
        ];

        $categoryMap = \App\Models\JobCategory::pluck('id', 'slug');

        foreach ($jobs as $j) {
            $company = $companyModels[$j['company_idx']];
            unset($j['company_idx']);

            $j['company_id'] = $company->id;
            $j['user_id'] = $company->user_id;
            $j['category_id'] = $categoryMap[$j['category_slug']] ?? null;
            unset($j['category_slug']);

            $j['slug'] = Str::slug($j['title']) . '-' . $company->id;
            $j['salary_currency'] = 'EUR';
            $j['status'] = 'active';
            $j['views_count'] = rand(50, 2000);
            $j['clicks_count'] = rand(10, 500);
            $j['applications_count'] = rand(2, 80);
            $j['expires_at'] = now()->addDays(rand(14, 90));

            Job::create($j);
        }
    }
}
