-- luacheck: globals describe it assert after_each
local _99 = require("99")
local test_utils = require("99.test.test_utils")
local eq = assert.are.same

local function setup(content, row, col)
    return test_utils.setup_test(content, "c", row, col)
end
local r = test_utils.lines

describe("C Scenarios", function()
    after_each(function()
        test_utils.clean_files()
    end)

    describe("basic functions", function()
        it("detects void function", function()
            local content = { "void print_hello(void) {", "}" }
            local p, _ = setup(content, 1, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "void print_hello(void) {"
            )
        end)

        it("detects static function", function()
            local content = { "static int helper(int x) {", "}" }
            local p, _ = setup(content, 1, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "static int helper(int x) {"
            )
        end)

        it("detects function with pointer return type", function()
            local content = { "char* get_name(void) {", "}" }
            local p, _ = setup(content, 1, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "char* get_name(void) {"
            )
        end)
    end)

    describe("structs", function()
        it("includes enclosing struct context", function()
            local content = {
                "struct Point {",
                "    int x;",
                "    int y;",
                "};",
                "",
                "int point_distance(struct Point* p1, struct Point* p2) {",
                "}",
            }
            local p, buffer = setup(content, 6, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "int point_distance(struct Point* p1, struct Point* p2) {"
            )

            p:resolve(
                "success",
                "int point_distance(struct Point* p1, struct Point* p2) {\n"
                    .. "    int dx = p2->x - p1->x;\n"
                    .. "    int dy = p2->y - p1->y;\n"
                    .. "    return dx*dx + dy*dy;\n}"
            )
            test_utils.next_frame()

            eq({
                "struct Point {",
                "    int x;",
                "    int y;",
                "};",
                "",
                "int point_distance(struct Point* p1, struct Point* p2) {",
                "    int dx = p2->x - p1->x;",
                "    int dy = p2->y - p1->y;",
                "    return dx*dx + dy*dy;",
                "}",
            }, r(buffer))
        end)
    end)

    describe("prototypes in buffer", function()
        it("includes prototype from same file", function()
            local content =
                { "int calculate(int x);", "", "int calculate(int x) {", "}" }
            local p, _ = setup(content, 3, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionPrototypes",
                "int calculate(int x);"
            )
        end)

        it("includes multiple prototypes when available", function()
            local content = {
                "int add(int a, int b);",
                "int subtract(int a, int b);",
                "",
                "int add(int a, int b) {",
                "}",
            }
            local p, _ = setup(content, 4, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionPrototypes",
                "int add(int a, int b);"
            )
        end)
    end)
end)
