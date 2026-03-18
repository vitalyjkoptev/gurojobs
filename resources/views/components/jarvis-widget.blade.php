{{-- Jarvis AI Voice Widget --}}
{{-- Include on admin/employer layouts --}}
@if(auth()->check() && in_array(auth()->user()->role, ['admin', 'employer']))
<script src="{{ asset('js/jarvis.js') }}"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        window.jarvisInstance = new Jarvis({
            apiUrl: '{{ url("/api/v1/jarvis/command") }}',
            authToken: '{{ auth()->user()->currentAccessToken()?->plainTextToken ?? "" }}',
            language: '{{ app()->getLocale() === "ru" ? "ru-RU" : "en-US" }}',
            wakeWord: 'jarvis',
            continuousMode: false,
        });
    });
</script>
@endif
