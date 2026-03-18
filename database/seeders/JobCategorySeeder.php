<?php

namespace Database\Seeders;

use App\Models\JobCategory;
use Illuminate\Database\Seeder;

class JobCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            // Core iGaming Operations
            ['name' => 'Casino Operations', 'slug' => 'casino-operations', 'icon' => 'bi-dice-5', 'description' => 'Online & land-based casino management, live casino, table games'],
            ['name' => 'Sports Betting', 'slug' => 'sports-betting', 'icon' => 'bi-trophy', 'description' => 'Sportsbook, odds compilation, trading, live betting'],
            ['name' => 'Poker', 'slug' => 'poker', 'icon' => 'bi-suit-spade', 'description' => 'Poker room management, tournaments, game integrity'],
            ['name' => 'eSports', 'slug' => 'esports', 'icon' => 'bi-controller', 'description' => 'eSports betting, tournament management, streaming'],
            ['name' => 'Lottery & Bingo', 'slug' => 'lottery-bingo', 'icon' => 'bi-grid-3x3', 'description' => 'Lottery operations, bingo, instant win games'],

            // Tech & Product
            ['name' => 'Game Development', 'slug' => 'game-development', 'icon' => 'bi-code-slash', 'description' => 'Slots, table games, live casino, RNG, game math'],
            ['name' => 'Platform & Backend', 'slug' => 'platform-backend', 'icon' => 'bi-server', 'description' => 'Platform development, API, microservices, scalability'],
            ['name' => 'Frontend & Mobile', 'slug' => 'frontend-mobile', 'icon' => 'bi-phone', 'description' => 'Web & mobile apps, UI/UX development, responsive design'],
            ['name' => 'IT & Infrastructure', 'slug' => 'it-infrastructure', 'icon' => 'bi-hdd-network', 'description' => 'DevOps, cloud, security, networking, system administration'],
            ['name' => 'QA & Testing', 'slug' => 'qa-testing', 'icon' => 'bi-bug', 'description' => 'Quality assurance, automated testing, game testing'],
            ['name' => 'Product & UX', 'slug' => 'product-ux', 'icon' => 'bi-palette', 'description' => 'Product management, UX/UI design, user research, A/B testing'],
            ['name' => 'Data & Analytics', 'slug' => 'data-analytics', 'icon' => 'bi-graph-up', 'description' => 'BI, data science, analytics, reporting, machine learning'],

            // Business & Marketing
            ['name' => 'Affiliate & Marketing', 'slug' => 'affiliate-marketing', 'icon' => 'bi-megaphone', 'description' => 'Affiliate management, digital marketing, SEO, PPC, CRM'],
            ['name' => 'Content & Copywriting', 'slug' => 'content-copywriting', 'icon' => 'bi-pencil-square', 'description' => 'Content creation, copywriting, localization, translation'],
            ['name' => 'VIP & Retention', 'slug' => 'vip-retention', 'icon' => 'bi-star', 'description' => 'VIP management, player retention, loyalty programs, CRM'],
            ['name' => 'Business Development', 'slug' => 'business-development', 'icon' => 'bi-briefcase', 'description' => 'B2B sales, partnerships, new markets, licensing'],

            // Compliance & Finance
            ['name' => 'Compliance & Legal', 'slug' => 'compliance-legal', 'icon' => 'bi-shield-check', 'description' => 'Regulatory compliance, licensing, responsible gaming, AML/KYC'],
            ['name' => 'Risk & Fraud', 'slug' => 'risk-fraud', 'icon' => 'bi-exclamation-triangle', 'description' => 'Fraud prevention, risk management, anti-money laundering'],
            ['name' => 'Payment & Fintech', 'slug' => 'payment-fintech', 'icon' => 'bi-credit-card', 'description' => 'Payment processing, crypto payments, cashier, treasury'],

            // People & Support
            ['name' => 'Customer Support', 'slug' => 'customer-support', 'icon' => 'bi-headset', 'description' => 'Player support, live chat, email support, escalation'],
            ['name' => 'HR & Recruitment', 'slug' => 'hr-recruitment', 'icon' => 'bi-people', 'description' => 'Talent acquisition, employer branding, L&D, HR operations'],

            // Traffic & Affiliate (from igaming-school.com)
            ['name' => 'Traffic & Media Buying', 'slug' => 'traffic-media-buying', 'icon' => 'bi-broadcast', 'description' => 'Traffic acquisition, media buying, arbitrage teams, CPA optimization'],
            ['name' => 'CPA & Affiliate Networks', 'slug' => 'cpa-affiliate-networks', 'icon' => 'bi-diagram-3', 'description' => 'CPA networks, affiliate programs, partner management'],

            // Providers & Platforms (from igaming-school.com)
            ['name' => 'Game Provider', 'slug' => 'game-provider', 'icon' => 'bi-puzzle', 'description' => 'Game content providers, slot studios, live dealer providers, RNG certification'],
            ['name' => 'Casino Platform', 'slug' => 'casino-platform', 'icon' => 'bi-layers', 'description' => 'Casino platform development, aggregation, white-label solutions'],
            ['name' => 'PSP & Payment Solutions', 'slug' => 'psp-payment-solutions', 'icon' => 'bi-wallet2', 'description' => 'Payment service providers, crypto gateways, cashier systems, PCI DSS'],

            // Project Management
            ['name' => 'Project Management', 'slug' => 'project-management', 'icon' => 'bi-kanban', 'description' => 'Project managers, Scrum masters, process automation, team leads'],

            // Executive
            ['name' => 'C-Level & Executive', 'slug' => 'c-level-executive', 'icon' => 'bi-building', 'description' => 'CEO, COO, CTO, CMO, CFO, CPO and other executive roles'],
        ];

        foreach ($categories as $i => $cat) {
            JobCategory::updateOrCreate(
                ['slug' => $cat['slug']],
                array_merge($cat, ['sort_order' => $i + 1])
            );
        }
    }
}
