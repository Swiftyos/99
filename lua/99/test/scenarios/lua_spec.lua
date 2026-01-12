-- luacheck: globals describe it assert after_each
local _99 = require("99")
local test_utils = require("99.test.test_utils")
local eq = assert.are.same

local function setup(content, row, col)
    return test_utils.setup_test(content, "lua", row, col)
end
local r = test_utils.lines

describe("Lua Scenarios", function()
    after_each(function()
        test_utils.clean_files()
    end)

    describe("basic functions", function()
        it("detects local function", function()
            local content = { "local function add(a, b)", "end" }
            local p, _ = setup(content, 1, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "local function add(a, b)"
            )
        end)

        it("detects anonymous function assigned to variable", function()
            local content = { "", "local foo = function() end" }
            local p, buffer = setup(content, 2, 12)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "function() end"
            )

            p:resolve("success", "function()\n    return 42\nend")
            test_utils.next_frame()
            eq(
                { "", "local foo = function()", "    return 42", "end" },
                r(buffer)
            )
        end)
    end)

    describe("method syntax", function()
        it("detects method with colon syntax", function()
            local content = {
                "local M = {}",
                "",
                "function M:greet(name)",
                "end",
                "",
                "return M",
            }
            local p, _ = setup(content, 3, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "function M:greet(name)"
            )
        end)

        it("detects method with dot syntax", function()
            local content = {
                "local M = {}",
                "",
                "function M.add(self, n)",
                "end",
                "",
                "return M",
            }
            local p, _ = setup(content, 3, 0)
            _99.fill_in_function()
            assert.is_not_nil(p.request)
            test_utils.assert_section_contains(
                p.request.query,
                "FunctionText",
                "function M.add(self, n)"
            )
        end)
    end)
end)
