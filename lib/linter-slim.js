'use babel';

// eslint-disable-next-line import/no-extraneous-dependencies, import/extensions
import { CompositeDisposable } from 'atom';

let helpers;

// Deprecated syntax:
const REGEX = /.*(SyntaxError|Deprecated).*: (.+)\n.+, Line (\d+), Column (\d+)/g;

const severityMapping = {
  deprecated: 'warning',
  syntaxerror: 'error',
};

const loadDeps = () => {
  if (!helpers) {
    helpers = require('atom-linter');
  }
};

const parseCompileOutput = (output, filePath, editor) => {
  const messages = [];

  let match = REGEX.exec(output);
  while (match !== null) {
    const severity = severityMapping[match[1].toLowerCase()] || 'warning';
    const line = Number.parseInt(match[3], 10) - 1;
    const col = Number.parseInt(match[4], 10) - 1;
    const excerpt = `${match[1]}: ${match[2]}`;
    messages.push({
      severity,
      excerpt,
      location: {
        file: filePath,
        position: helpers.generateRange(editor, line, col),
      },
    });
    match = REGEX.exec(output);
  }
  return messages;
};

module.exports = {
  activate() {
    this.idleCallbacks = new Set();
    let depsCallbackID;
    const installLinterSlimDeps = () => {
      this.idleCallbacks.delete(depsCallbackID);
      if (!atom.inSpecMode()) {
        require('atom-package-deps').install('linter-slim');
      }
      loadDeps();
    };
    depsCallbackID = window.requestIdleCallback(installLinterSlimDeps);
    this.idleCallbacks.add(depsCallbackID);

    this.subscriptions = new CompositeDisposable();
    this.subscriptions.add(
      atom.config.observe(
        'linter-slim.slimrbExecutablePath',
        (value) => { this.slimrbExecutablePath = value; },
      ),
      atom.config.observe(
        'linter-slim.rails',
        (value) => { this.rails = value; },
      ),
      atom.config.observe(
        'linter-slim.library',
        (value) => { this.library = value; },
      ),
    );
  },

  deactivate() {
    this.idleCallbacks.forEach(callbackID => window.cancelIdleCallback(callbackID));
    this.idleCallbacks.clear();
    this.subscriptions.dispose();
  },

  provideLinter() {
    return {
      name: 'slimrb',
      grammarScopes: ['text.slim'],
      scope: 'file',
      lintsOnChange: true,
      lint: async (editor) => {
        loadDeps();

        const filePath = editor.getPath();
        if (!filePath) {
          return null;
        }

        const args = [];
        args.push('--compile');

        if (this.rails) {
          args.push('--rails');
        }

        if (Array.isArray(this.library) && this.library.length) {
          args.push('--require', this.library.join(' '));
        }

        args.push(filePath);

        const execOptions = {
          stream: 'stderr',
          uniqueKey: `linter-slim::${filePath}`,
          allowEmptyStderr: true,
        };

        let output;
        try {
          output = await helpers.exec(this.slimrbExecutablePath, args, execOptions);
        } catch (e) {
          if (e.message === 'Process execution timed out') {
            atom.notifications.addInfo('linter-slim: `slimrb` timed out', {
              description: 'A timeout occured while executing `slimrb`, it could be due to lower resources '
                           + 'or a temporary overload.',
            });
          } else {
            atom.notifications.addError('linter-slimrb: Unexpected error', { description: e.message });
          }
          return null;
        }

        // Process was canceled by newer process
        if (output === null) { return null; }

        return parseCompileOutput(output, filePath, editor);
      },
    };
  },
};
