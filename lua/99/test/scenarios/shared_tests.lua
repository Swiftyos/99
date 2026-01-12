local M = {}

M.simple_function = {
    c = {
        code = { "int add(int a, int b) {", "}" },
        row = 1,
        col = 0,
        check = "int add(int a, int b) {",
        resolve = "int add(int a, int b) {\n    return a + b;\n}",
        expect = { "int add(int a, int b) {", "    return a + b;", "}" },
    },
    python = {
        code = { "def greet(name):", "    pass" },
        row = 1,
        col = 0,
        check = "def greet(name):",
        resolve = 'def greet(name):\n    return f"Hello, {name}!"',
        expect = { "def greet(name):", '    return f"Hello, {name}!"' },
    },
    go = {
        code = { "package main", "", "func greet(name string) string {", "}" },
        row = 3,
        col = 0,
        check = "func greet(name string) string {",
        resolve = 'func greet(name string) string {\n\treturn "Hello, " + name\n}',
        expect = {
            "package main",
            "",
            "func greet(name string) string {",
            '\treturn "Hello, " + name',
            "}",
        },
    },
    ruby = {
        code = { "def greet(name)", "end" },
        row = 1,
        col = 0,
        check = "def greet(name)",
        resolve = 'def greet(name)\n  "Hello, #{name}!"\nend',
        expect = { "def greet(name)", '  "Hello, #{name}!"', "end" },
    },
    rust = {
        code = { "fn greet(name: &str) -> String {", "}" },
        row = 1,
        col = 0,
        check = "fn greet(name: &str) -> String {",
        resolve = 'fn greet(name: &str) -> String {\n    format!("Hello, {}!", name)\n}',
        expect = {
            "fn greet(name: &str) -> String {",
            '    format!("Hello, {}!", name)',
            "}",
        },
    },
    lua = {
        code = { "function greet(name)", "end" },
        row = 1,
        col = 0,
        check = "function greet(name)",
        resolve = 'function greet(name)\n    return "Hello, " .. name\nend',
        expect = {
            "function greet(name)",
            '    return "Hello, " .. name',
            "end",
        },
    },
    typescript = {
        code = { "function greet(name: string): string {", "}" },
        row = 1,
        col = 0,
        check = "function greet(name: string): string {",
        resolve = "function greet(name: string): string {\n    return `Hello, ${name}!`;\n}",
        expect = {
            "function greet(name: string): string {",
            "    return `Hello, ${name}!`;",
            "}",
        },
    },
}

M.single_comment = {
    c = {
        code = {
            "// Adds two integers together",
            "int add(int a, int b) {",
            "}",
        },
        row = 2,
        col = 0,
        check = "// Adds two integers together",
    },
    python = {
        code = {
            "# This function greets a user",
            "def greet(name):",
            "    pass",
        },
        row = 2,
        col = 0,
        check = "# This function greets a user",
    },
    go = {
        code = {
            "package main",
            "",
            "// Greet returns a greeting message",
            "func greet(name string) string {",
            "}",
        },
        row = 4,
        col = 0,
        check = "// Greet returns a greeting message",
    },
    ruby = {
        code = { "# Greets the user by name", "def greet(name)", "end" },
        row = 2,
        col = 0,
        check = "# Greets the user by name",
    },
    rust = {
        code = {
            "/// Greets the user by name",
            "fn greet(name: &str) -> String {",
            "}",
        },
        row = 2,
        col = 0,
        check = "/// Greets the user by name",
    },
    lua = {
        code = { "-- Greets the user by name", "function greet(name)", "end" },
        row = 2,
        col = 0,
        check = "-- Greets the user by name",
    },
    typescript = {
        code = {
            "// Process the input data",
            "function process(data: Buffer): void {",
            "}",
        },
        row = 2,
        col = 0,
        check = "// Process the input data",
    },
}

M.multi_line_comment = {
    c = {
        code = {
            "/*",
            " * Process the data",
            " * and return the result",
            " */",
            "int process(int* data, int len) {",
            "}",
        },
        row = 5,
        col = 0,
        checks = { "Process the data" },
    },
    python = {
        code = {
            "# First line of documentation",
            "# Second line",
            "def process(data):",
            "    pass",
        },
        row = 3,
        col = 0,
        checks = { "# First line of documentation", "# Second line" },
    },
    go = {
        code = {
            "package main",
            "",
            "// Process handles the data",
            "// and returns the result",
            "func process(data []byte) error {",
            "}",
        },
        row = 5,
        col = 0,
        checks = { "// Process handles the data", "// and returns the result" },
    },
    ruby = {
        code = {
            "# Process the input data",
            "# and return the result",
            "def process(data)",
            "end",
        },
        row = 3,
        col = 0,
        checks = { "# Process the input data", "# and return the result" },
    },
    rust = {
        code = {
            "/// Process the input data",
            "/// and return the result",
            "fn process(data: &[u8]) -> Result<(), Error> {",
            "}",
        },
        row = 3,
        col = 0,
        checks = { "/// Process the input data", "/// and return the result" },
    },
    lua = {
        code = {
            "-- Process the input",
            "-- and return result",
            "function process(data)",
            "end",
        },
        row = 3,
        col = 0,
        checks = { "-- Process the input", "-- and return result" },
    },
    typescript = {
        code = {
            "/** Greets the user by name */",
            "function greet(name: string): string {",
            "}",
        },
        row = 2,
        col = 0,
        checks = { "/** Greets the user by name */" },
    },
}

M.cancel_request = {
    c = { code = { "void cancel_me(void) {", "}" }, row = 1, col = 0 },
    python = { code = { "def cancel_me():", "    pass" }, row = 1, col = 0 },
    go = {
        code = { "package main", "", "func cancelMe() {", "}" },
        row = 3,
        col = 0,
    },
    ruby = { code = { "def cancel_me", "end" }, row = 1, col = 0 },
    rust = { code = { "fn cancel_me() {", "}" }, row = 1, col = 0 },
    lua = { code = { "function cancel_me()", "end" }, row = 1, col = 0 },
    typescript = {
        code = { "function cancelMe(): void {", "}" },
        row = 1,
        col = 0,
    },
}

M.error_response = {
    c = { code = { "void error_case(void) {", "}" }, row = 1, col = 0 },
    python = { code = { "def error_case():", "    pass" }, row = 1, col = 0 },
    go = {
        code = { "package main", "", "func errorCase() {", "}" },
        row = 3,
        col = 0,
    },
    ruby = { code = { "def error_case", "end" }, row = 1, col = 0 },
    rust = { code = { "fn error_case() {", "}" }, row = 1, col = 0 },
    lua = { code = { "function error_case()", "end" }, row = 1, col = 0 },
    typescript = {
        code = { "function errorCase(): void {", "}" },
        row = 1,
        col = 0,
    },
}

return M
