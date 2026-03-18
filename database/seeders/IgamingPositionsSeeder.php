<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

/**
 * iGaming positions dictionary for keyword search autocomplete.
 * Source: igaming-school.com, guro.school, industry standards.
 *
 * Users search by typing "CMO" or "slot developer" — this table
 * powers autocomplete suggestions and search highlighting.
 */
class IgamingPositionsSeeder extends Seeder
{
    public function run(): void
    {
        $positions = [
            // ── C-Level / Executive ──────────────────────────────────
            ['title' => 'CEO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Executive Officer,General Director,Managing Director'],
            ['title' => 'COO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Operating Officer,Operations Director'],
            ['title' => 'CTO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Technology Officer,VP Engineering,Tech Director'],
            ['title' => 'CMO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Marketing Officer,Marketing Director,VP Marketing'],
            ['title' => 'CFO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Financial Officer,Finance Director'],
            ['title' => 'CPO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Product Officer,VP Product'],
            ['title' => 'CCO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Commercial Officer,Chief Compliance Officer'],
            ['title' => 'CRO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Revenue Officer,Chief Risk Officer'],
            ['title' => 'CHRO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief HR Officer,VP People'],
            ['title' => 'CDO', 'category' => 'c-level-executive', 'level' => 'c-level', 'aliases' => 'Chief Data Officer,Chief Digital Officer'],

            // ── Casino Operations ────────────────────────────────────
            ['title' => 'Casino Manager', 'category' => 'casino-operations', 'level' => 'head', 'aliases' => 'Online Casino Manager,Casino Director'],
            ['title' => 'Live Casino Manager', 'category' => 'casino-operations', 'level' => 'head', 'aliases' => 'Live Dealer Manager,Live Games Manager'],
            ['title' => 'Casino Operations Analyst', 'category' => 'casino-operations', 'level' => 'middle', 'aliases' => 'Gaming Analyst'],
            ['title' => 'Table Games Manager', 'category' => 'casino-operations', 'level' => 'head', 'aliases' => 'Games Manager'],
            ['title' => 'Responsible Gaming Manager', 'category' => 'casino-operations', 'level' => 'head', 'aliases' => 'Player Protection Manager'],

            // ── Sports Betting ───────────────────────────────────────
            ['title' => 'Sportsbook Manager', 'category' => 'sports-betting', 'level' => 'head', 'aliases' => 'Betting Manager,Bookmaker'],
            ['title' => 'Odds Compiler', 'category' => 'sports-betting', 'level' => 'middle', 'aliases' => 'Odds Analyst,Trading Analyst,Trader'],
            ['title' => 'Sports Trader', 'category' => 'sports-betting', 'level' => 'middle', 'aliases' => 'Live Trader,In-Play Trader'],
            ['title' => 'Head of Sportsbook', 'category' => 'sports-betting', 'level' => 'head', 'aliases' => 'Director of Betting'],
            ['title' => 'Betting Risk Analyst', 'category' => 'sports-betting', 'level' => 'middle', 'aliases' => 'Risk Trader'],

            // ── Game Development ─────────────────────────────────────
            ['title' => 'Slot Developer', 'category' => 'game-development', 'level' => 'middle', 'aliases' => 'Slot Game Developer,Casino Game Developer'],
            ['title' => 'Game Mathematician', 'category' => 'game-development', 'level' => 'senior', 'aliases' => 'Game Math,RNG Specialist'],
            ['title' => 'Game Designer', 'category' => 'game-development', 'level' => 'middle', 'aliases' => 'iGaming Game Designer'],
            ['title' => 'Game Producer', 'category' => 'game-development', 'level' => 'senior', 'aliases' => 'Studio Producer'],
            ['title' => 'Game Artist', 'category' => 'game-development', 'level' => 'middle', 'aliases' => '2D Artist,3D Artist,Slot Artist'],
            ['title' => 'Game Animator', 'category' => 'game-development', 'level' => 'middle', 'aliases' => 'Slot Animator,Motion Designer'],
            ['title' => 'Unity Developer', 'category' => 'game-development', 'level' => 'middle', 'aliases' => 'Unity Engineer,C# Developer'],
            ['title' => 'HTML5 Game Developer', 'category' => 'game-development', 'level' => 'middle', 'aliases' => 'Canvas Developer,PixiJS Developer'],

            // ── Platform & Backend ───────────────────────────────────
            ['title' => 'Backend Developer', 'category' => 'platform-backend', 'level' => 'middle', 'aliases' => 'PHP Developer,Java Developer,Go Developer,Node.js Developer'],
            ['title' => 'Platform Architect', 'category' => 'platform-backend', 'level' => 'senior', 'aliases' => 'Solutions Architect,System Architect'],
            ['title' => 'Integration Engineer', 'category' => 'platform-backend', 'level' => 'middle', 'aliases' => 'API Developer,Integration Developer'],
            ['title' => 'Database Administrator', 'category' => 'platform-backend', 'level' => 'middle', 'aliases' => 'DBA,Database Engineer'],

            // ── Frontend & Mobile ────────────────────────────────────
            ['title' => 'Frontend Developer', 'category' => 'frontend-mobile', 'level' => 'middle', 'aliases' => 'React Developer,Vue Developer,Angular Developer'],
            ['title' => 'Mobile Developer', 'category' => 'frontend-mobile', 'level' => 'middle', 'aliases' => 'iOS Developer,Android Developer,Flutter Developer,React Native Developer'],
            ['title' => 'UI/UX Designer', 'category' => 'frontend-mobile', 'level' => 'middle', 'aliases' => 'Product Designer,UX Designer,UI Designer'],

            // ── IT & Infrastructure ──────────────────────────────────
            ['title' => 'DevOps Engineer', 'category' => 'it-infrastructure', 'level' => 'middle', 'aliases' => 'SRE,Platform Engineer,Cloud Engineer'],
            ['title' => 'Security Engineer', 'category' => 'it-infrastructure', 'level' => 'senior', 'aliases' => 'InfoSec,Cybersecurity Engineer,Security Analyst'],
            ['title' => 'System Administrator', 'category' => 'it-infrastructure', 'level' => 'middle', 'aliases' => 'SysAdmin,Linux Admin'],
            ['title' => 'Network Engineer', 'category' => 'it-infrastructure', 'level' => 'middle', 'aliases' => 'Network Admin'],

            // ── QA & Testing ─────────────────────────────────────────
            ['title' => 'QA Engineer', 'category' => 'qa-testing', 'level' => 'middle', 'aliases' => 'QA Tester,Quality Analyst'],
            ['title' => 'QA Automation Engineer', 'category' => 'qa-testing', 'level' => 'senior', 'aliases' => 'SDET,Test Automation'],
            ['title' => 'Game Tester', 'category' => 'qa-testing', 'level' => 'junior', 'aliases' => 'Casino Game Tester,Slot Tester'],

            // ── Data & Analytics ─────────────────────────────────────
            ['title' => 'Data Analyst', 'category' => 'data-analytics', 'level' => 'middle', 'aliases' => 'BI Analyst,Gaming Analyst,Business Analyst'],
            ['title' => 'Data Scientist', 'category' => 'data-analytics', 'level' => 'senior', 'aliases' => 'ML Engineer,AI Engineer'],
            ['title' => 'Data Engineer', 'category' => 'data-analytics', 'level' => 'middle', 'aliases' => 'ETL Developer,Data Pipeline Engineer'],
            ['title' => 'BI Developer', 'category' => 'data-analytics', 'level' => 'middle', 'aliases' => 'Tableau Developer,Power BI Developer'],

            // ── Affiliate & Marketing ────────────────────────────────
            ['title' => 'Affiliate Manager', 'category' => 'affiliate-marketing', 'level' => 'middle', 'aliases' => 'Partner Manager,Affiliate Account Manager'],
            ['title' => 'Head of Affiliates', 'category' => 'affiliate-marketing', 'level' => 'head', 'aliases' => 'Director of Affiliates,VP Affiliates'],
            ['title' => 'Digital Marketing Manager', 'category' => 'affiliate-marketing', 'level' => 'head', 'aliases' => 'Marketing Manager,Online Marketing'],
            ['title' => 'SEO Manager', 'category' => 'affiliate-marketing', 'level' => 'middle', 'aliases' => 'SEO Specialist,SEO Lead'],
            ['title' => 'PPC Manager', 'category' => 'affiliate-marketing', 'level' => 'middle', 'aliases' => 'Paid Ads Manager,SEM Manager'],
            ['title' => 'Social Media Manager', 'category' => 'affiliate-marketing', 'level' => 'middle', 'aliases' => 'SMM Manager,Community Manager'],
            ['title' => 'CRM Manager', 'category' => 'affiliate-marketing', 'level' => 'middle', 'aliases' => 'Lifecycle Manager,Email Marketing Manager'],
            ['title' => 'Brand Manager', 'category' => 'affiliate-marketing', 'level' => 'senior', 'aliases' => 'Brand Strategist'],

            // ── Traffic & Media Buying ───────────────────────────────
            ['title' => 'Media Buyer', 'category' => 'traffic-media-buying', 'level' => 'middle', 'aliases' => 'Traffic Manager,Paid Media Specialist'],
            ['title' => 'Head of Traffic', 'category' => 'traffic-media-buying', 'level' => 'head', 'aliases' => 'Traffic Lead,Acquisition Director'],
            ['title' => 'Arbitrage Team Lead', 'category' => 'traffic-media-buying', 'level' => 'head', 'aliases' => 'Traffic Arbitrage Lead'],

            // ── CPA & Affiliate Networks ─────────────────────────────
            ['title' => 'CPA Network Manager', 'category' => 'cpa-affiliate-networks', 'level' => 'head', 'aliases' => 'Network Director'],
            ['title' => 'Account Manager', 'category' => 'cpa-affiliate-networks', 'level' => 'middle', 'aliases' => 'Advertiser Manager,Publisher Manager'],

            // ── Content & Copy ───────────────────────────────────────
            ['title' => 'Content Manager', 'category' => 'content-copywriting', 'level' => 'middle', 'aliases' => 'Content Lead,Editorial Manager'],
            ['title' => 'Copywriter', 'category' => 'content-copywriting', 'level' => 'middle', 'aliases' => 'iGaming Copywriter,Casino Copywriter'],
            ['title' => 'Translator', 'category' => 'content-copywriting', 'level' => 'middle', 'aliases' => 'Localization Specialist,Language Specialist'],

            // ── VIP & Retention ──────────────────────────────────────
            ['title' => 'VIP Manager', 'category' => 'vip-retention', 'level' => 'senior', 'aliases' => 'VIP Host,High Roller Manager,VIP Account Manager'],
            ['title' => 'Retention Manager', 'category' => 'vip-retention', 'level' => 'middle', 'aliases' => 'Player Retention,Re-engagement Manager'],
            ['title' => 'Bonus Manager', 'category' => 'vip-retention', 'level' => 'middle', 'aliases' => 'Promotions Manager,Campaigns Manager'],

            // ── Compliance & Legal ───────────────────────────────────
            ['title' => 'Compliance Officer', 'category' => 'compliance-legal', 'level' => 'senior', 'aliases' => 'Compliance Manager,Regulatory Affairs'],
            ['title' => 'AML Analyst', 'category' => 'compliance-legal', 'level' => 'middle', 'aliases' => 'Anti-Money Laundering Analyst,KYC Analyst'],
            ['title' => 'Legal Counsel', 'category' => 'compliance-legal', 'level' => 'senior', 'aliases' => 'In-House Lawyer,Legal Advisor,Gaming Lawyer'],
            ['title' => 'Licensing Manager', 'category' => 'compliance-legal', 'level' => 'senior', 'aliases' => 'Regulatory Manager,Licensing Specialist'],

            // ── Risk & Fraud ─────────────────────────────────────────
            ['title' => 'Fraud Analyst', 'category' => 'risk-fraud', 'level' => 'middle', 'aliases' => 'Fraud Investigator,Fraud Prevention Analyst'],
            ['title' => 'Risk Manager', 'category' => 'risk-fraud', 'level' => 'senior', 'aliases' => 'Head of Risk,Risk Director'],

            // ── Payment & Fintech ────────────────────────────────────
            ['title' => 'Payment Manager', 'category' => 'payment-fintech', 'level' => 'middle', 'aliases' => 'Payments Lead,Cashier Manager'],
            ['title' => 'PSP Integration Engineer', 'category' => 'psp-payment-solutions', 'level' => 'middle', 'aliases' => 'Payment Gateway Developer'],
            ['title' => 'Treasury Manager', 'category' => 'payment-fintech', 'level' => 'senior', 'aliases' => 'Finance Manager'],

            // ── Customer Support ─────────────────────────────────────
            ['title' => 'Customer Support Agent', 'category' => 'customer-support', 'level' => 'junior', 'aliases' => 'Support Agent,Live Chat Agent,CS Agent'],
            ['title' => 'Customer Support Team Lead', 'category' => 'customer-support', 'level' => 'head', 'aliases' => 'CS Team Lead,Support Lead'],
            ['title' => 'Head of Customer Support', 'category' => 'customer-support', 'level' => 'head', 'aliases' => 'CS Director,Support Director'],

            // ── HR & Recruitment ─────────────────────────────────────
            ['title' => 'iGaming Recruiter', 'category' => 'hr-recruitment', 'level' => 'middle', 'aliases' => 'Tech Recruiter,Talent Acquisition Specialist,HR Recruiter'],
            ['title' => 'HR Manager', 'category' => 'hr-recruitment', 'level' => 'head', 'aliases' => 'Head of HR,People Manager'],
            ['title' => 'HR Business Partner', 'category' => 'hr-recruitment', 'level' => 'senior', 'aliases' => 'HRBP'],

            // ── Business Development ─────────────────────────────────
            ['title' => 'Business Development Manager', 'category' => 'business-development', 'level' => 'senior', 'aliases' => 'BDM,BD Manager,Partnerships Manager'],
            ['title' => 'Sales Manager', 'category' => 'business-development', 'level' => 'middle', 'aliases' => 'B2B Sales,Account Executive'],
            ['title' => 'Country Manager', 'category' => 'business-development', 'level' => 'head', 'aliases' => 'Market Manager,Regional Manager'],

            // ── Product & UX ─────────────────────────────────────────
            ['title' => 'Product Manager', 'category' => 'product-ux', 'level' => 'senior', 'aliases' => 'Product Owner,PM'],
            ['title' => 'Product Director', 'category' => 'product-ux', 'level' => 'head', 'aliases' => 'Head of Product,VP Product'],

            // ── Project Management ───────────────────────────────────
            ['title' => 'Project Manager', 'category' => 'project-management', 'level' => 'middle', 'aliases' => 'PM,Delivery Manager'],
            ['title' => 'Scrum Master', 'category' => 'project-management', 'level' => 'middle', 'aliases' => 'Agile Coach,Agile Lead'],

            // ── Game Provider ────────────────────────────────────────
            ['title' => 'Studio Director', 'category' => 'game-provider', 'level' => 'head', 'aliases' => 'Head of Studio,Game Studio Manager'],
            ['title' => 'Content Manager (Provider)', 'category' => 'game-provider', 'level' => 'middle', 'aliases' => 'Game Content Manager'],

            // ── Casino Platform ──────────────────────────────────────
            ['title' => 'Platform Manager', 'category' => 'casino-platform', 'level' => 'head', 'aliases' => 'White Label Manager,Platform Director'],
        ];

        DB::table('igaming_positions')->truncate();

        foreach ($positions as $pos) {
            DB::table('igaming_positions')->insert([
                'title' => $pos['title'],
                'category_slug' => $pos['category'],
                'experience_level' => $pos['level'],
                'aliases' => $pos['aliases'],
                'created_at' => now(),
            ]);
        }
    }
}
