defmodule K8s.Cluster.DiscoveryTest do
  use ExUnit.Case, async: true

  alias K8s.Cluster.Discovery

  describe "api_version/1" do
    test "returns a list of API versions" do
      cluster = :test
      file = "test/support/discovery/sample_api_versions.json"
      {:ok, api_versions} = Discovery.api_versions(cluster, path: file)

      assert Enum.member?(api_versions, "v1")
      assert Enum.member?(api_versions, "batch/v1")
    end
  end

  describe "resource_identifiers/1" do
    test "returns a list of resource identifiers" do
      cluster = :test
      file = "test/support/discovery/sample_resource_definitions.json"
      {:ok, resource_identifiers} = Discovery.resource_identifiers(cluster, path: file)

      assert resource_identifiers == [
               {"batch/v1", "Job", "jobs"},
               {"apps/v1", "DaemonSet", "daemonsets"},
               {"apps/v1", "Deployment", "deployments"},
               {"apps/v1", "Deployment", "deployments/status"},
               {"v1", "Namespace", "namespaces"}
             ]
    end
  end

  describe "resource_definitions/1" do
    test "returns full resource definitions" do
      cluster = :test
      file = "test/support/discovery/sample_resource_definitions.json"
      {:ok, resource_definitions} = Discovery.resource_definitions(cluster, path: file)

      assert Enum.member?(resource_definitions, %{
               "groupVersion" => "v1",
               "kind" => "APIResourceList",
               "resources" => [
                 %{
                   "kind" => "Namespace",
                   "name" => "namespaces"
                 }
               ]
             })

      assert length(resource_definitions) > 1
    end
  end
end
