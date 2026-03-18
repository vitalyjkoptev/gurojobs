@extends('admin.partials.layouts.master')

@section('title', 'Payments — GURO JOBS Admin')
@section('pagetitle', 'Admin')
@section('sub-title', 'Payments')

@section('content')

<!-- Stats -->
<div class="row g-3 mb-4">
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-primary-subtle text-primary rounded-2"><i class="ri-bank-card-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Total Payments</p><h4 class="mb-0 fw-semibold">{{ $payments->total() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-success-subtle text-success rounded-2"><i class="ri-money-dollar-circle-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Completed Revenue</p><h4 class="mb-0 fw-semibold">${{ number_format(\App\Models\Payment::completed()->sum('amount'), 2) }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-warning-subtle text-warning rounded-2"><i class="ri-time-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Pending</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Payment::pending()->count() }}</h4></div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6">
        <div class="card card-h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="avatar avatar-sm bg-info-subtle text-info rounded-2"><i class="ri-bit-coin-line fs-18"></i></div>
                <div><p class="text-muted mb-0 fs-13">Crypto Payments</p><h4 class="mb-0 fw-semibold">{{ \App\Models\Payment::where('payment_method', 'crypto')->count() }}</h4></div>
            </div>
        </div>
    </div>
</div>

<!-- Filters -->
<div class="card mb-3">
    <div class="card-body py-2">
        <form class="row g-2 align-items-center" method="GET">
            <div class="col-md-3"><input type="text" name="q" class="form-control form-control-sm" placeholder="Search user or payment ID..." value="{{ request('q') }}"></div>
            <div class="col-md-2">
                <select name="status" class="form-select form-select-sm">
                    <option value="">All Statuses</option>
                    <option value="completed" {{ request('status')==='completed'?'selected':'' }}>Completed</option>
                    <option value="pending" {{ request('status')==='pending'?'selected':'' }}>Pending</option>
                    <option value="failed" {{ request('status')==='failed'?'selected':'' }}>Failed</option>
                    <option value="refunded" {{ request('status')==='refunded'?'selected':'' }}>Refunded</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="method" class="form-select form-select-sm">
                    <option value="">All Methods</option>
                    <option value="stripe" {{ request('method')==='stripe'?'selected':'' }}>Stripe</option>
                    <option value="crypto" {{ request('method')==='crypto'?'selected':'' }}>Crypto</option>
                    <option value="apple_pay" {{ request('method')==='apple_pay'?'selected':'' }}>Apple Pay</option>
                    <option value="google_pay" {{ request('method')==='google_pay'?'selected':'' }}>Google Pay</option>
                </select>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-primary"><i class="ri-filter-3-line me-1"></i>Filter</button>
                <a href="{{ route('admin.payments') }}" class="btn btn-sm btn-light">Reset</a>
            </div>
        </form>
    </div>
</div>

<!-- Payments Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width:40px"><input class="form-check-input" type="checkbox" id="selectAll"></th>
                        <th>Payment ID</th>
                        <th>User</th>
                        <th>Type</th>
                        <th>Plan</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th style="width:80px">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($payments as $payment)
                    <tr>
                        <td><input class="form-check-input row-check" type="checkbox" value="{{ $payment->id }}"></td>
                        <td>
                            <span class="fw-medium text-primary">#{{ $payment->id }}</span>
                            @if($payment->payment_id)
                                <br><span class="text-muted fs-11">{{ Str::limit($payment->payment_id, 20) }}</span>
                            @endif
                        </td>
                        <td>
                            @if($payment->user)
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar-item avatar-xs avatar-title rounded-circle text-white" style="background:var(--bs-primary);font-size:11px;width:28px;height:28px;">{{ strtoupper(substr($payment->user->name,0,1)) }}</div>
                                    <div>
                                        <span class="fw-medium fs-13">{{ $payment->user->name }}</span><br>
                                        <span class="text-muted fs-12">{{ $payment->user->email }}</span>
                                    </div>
                                </div>
                            @else <span class="text-muted">Deleted user</span>
                            @endif
                        </td>
                        <td><span class="badge bg-light text-dark">{{ ucfirst($payment->type ?? 'subscription') }}</span></td>
                        <td class="text-muted fs-13">{{ ucfirst($payment->plan ?? '—') }}</td>
                        <td class="fw-semibold">
                            {{ $payment->currency ?? 'USD' }} {{ number_format($payment->amount, 2) }}
                        </td>
                        <td>
                            @php
                                $mi = match($payment->payment_method?->value ?? 'stripe'){
                                    'stripe'=>'ri-bank-card-line text-primary','crypto'=>'ri-bit-coin-line text-warning',
                                    'apple_pay'=>'ri-apple-line text-dark','google_pay'=>'ri-google-line text-success',default=>'ri-bank-card-line text-muted'
                                };
                            @endphp
                            <i class="{{ $mi }} me-1"></i>{{ ucfirst(str_replace('_',' ', $payment->payment_method?->value ?? 'stripe')) }}
                        </td>
                        <td>
                            @php $psc = match($payment->status ?? 'pending'){ 'completed'=>'success','pending'=>'warning','failed'=>'danger','refunded'=>'info',default=>'secondary' }; @endphp
                            <span class="badge bg-{{ $psc }}-subtle text-{{ $psc }}">{{ ucfirst($payment->status ?? 'pending') }}</span>
                        </td>
                        <td class="text-muted fs-12">{{ $payment->created_at->format('M d, Y') }}</td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-subtle-secondary" data-bs-toggle="dropdown"><i class="ri-more-2-fill"></i></button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="#"><i class="ri-eye-line me-2"></i>View Details</a></li>
                                    @if(($payment->status ?? 'pending') === 'completed')
                                        <li><a class="dropdown-item text-info" href="#"><i class="ri-refund-line me-2"></i>Refund</a></li>
                                    @endif
                                    <li><a class="dropdown-item" href="#"><i class="ri-file-download-line me-2"></i>Receipt</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="10" class="text-center text-muted py-5">
                            <i class="ri-bank-card-line fs-1 d-block mb-2 opacity-50"></i>No payments found
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
    @if($payments->hasPages())
    <div class="card-footer">{{ $payments->withQueryString()->links() }}</div>
    @endif
</div>
@endsection

@section('js')
<script>document.getElementById('selectAll')?.addEventListener('change',function(){document.querySelectorAll('.row-check').forEach(c=>c.checked=this.checked);});</script>
@endsection
