'use babel';

import * as path from 'path';
import {
  // eslint-disable-next-line no-unused-vars
  it, fit, wait, beforeEach, afterEach,
} from 'jasmine-fix';

const { lint } = require('../lib/linter-slim.js').provideLinter();

const goodFile = path.join(__dirname, 'fixtures', 'good.slim');
const badFile = path.join(__dirname, 'fixtures', 'syntax_error.slim');
const deprecatedFile = path.join(__dirname, 'fixtures', 'deprecation_warning.slim');

describe('The slimrb provider for Linter', () => {
  beforeEach(async () => {
    atom.workspace.destroyActivePaneItem();
    await atom.packages.activatePackage('language-slim');
    await atom.packages.activatePackage('linter-slim');
  });

  it('checks a file with syntax error and reports the correct message', async () => {
    const excerpt = 'SyntaxError: Unknown line indicator';
    const editor = await atom.workspace.open(badFile);
    const messages = await lint(editor);

    expect(messages.length).toBe(1);
    expect(messages[0].severity).toBe('error');
    expect(messages[0].excerpt).toBe(excerpt);
    expect(messages[0].location.file).toBe(badFile);
    expect(messages[0].location.position).toEqual([[4, 2], [4, 9]]);
  });

  it('checks a file with a deprecation warning and reports the correct message', async () => {
    const excerpt = "Deprecated: =' for trailing whitespace is deprecated in favor of =>";
    const editor = await atom.workspace.open(deprecatedFile);
    const messages = await lint(editor);

    expect(messages.length).toBe(1);
    expect(messages[0].severity).toBe('warning');
    expect(messages[0].excerpt).toBe(excerpt);
    expect(messages[0].location.file).toBe(deprecatedFile);
    expect(messages[0].location.position).toEqual([[3, 2], [3, 10]]);
  });

  it('finds nothing wrong with a valid file', async () => {
    const editor = await atom.workspace.open(goodFile);
    const messages = await lint(editor);
    expect(messages.length).toBe(0);
  });
});
