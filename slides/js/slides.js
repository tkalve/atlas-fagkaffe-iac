import 'https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.4.0/plugin/highlight/highlight.min.js';
import 'https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.4.0/plugin/markdown/markdown.min.js';
import 'https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.4.0/plugin/notes/notes.min.js';
import 'https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.4.0/reveal.min.js';

Reveal.initialize({
    history: true,
    progress: true,
    transition: 'linear',
    plugins: [ RevealMarkdown, RevealHighlight, RevealNotes  ] 
});