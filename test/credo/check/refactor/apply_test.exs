defmodule Credo.Check.Refactor.ApplyTest do
  use Credo.Test.Case

  @described_check Credo.Check.Refactor.Apply

  test "it should NOT report violation for apply/2" do
    """
    defmodule Test do
      def some_function(fun, args) do
        apply(fun, args)
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report violation for apply/3" do
    """
    defmodule Test do
      def some_function(module, fun, args) do
        apply(module, fun, args)
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report violation for apply/3 when fun is a var" do
    """
    defmodule Test do
      def some_function(module, fun, arg1, arg2) do
        apply(module, fun, [arg1, arg2])
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report violation for apply/3 when fun is a function" do
    ~S"""
    defmodule Test do
      def some_function(module, fun, arg1, arg2) do
        apply(module, String.to_exisiting_atom("pre_#{fun}"), [arg1, arg2])
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should NOT report violation for apply/3 when args is a var" do
    ~S"""
    defmodule Test do
      def some_function(args) when is_list(args) do
        apply(Module, :fun, args)
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> refute_issues()
  end

  test "it should report violation for apply/2" do
    """
    defmodule Test do
      def some_function(fun, arg1, arg2) do
        apply(fun, [arg1, arg2])
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end

  test "it should report a violation for apply/3" do
    """
    defmodule Test do
      def some_function(module, arg1, arg2) do
        apply(module, :fun_name, [arg1, arg2])
      end
    end
    """
    |> to_source_file
    |> run_check(@described_check)
    |> assert_issue()
  end
end
