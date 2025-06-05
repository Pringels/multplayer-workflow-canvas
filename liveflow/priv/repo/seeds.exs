# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Liveflow.Repo.insert!(%Liveflow.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Liveflow.Seeds

# Clear existing data (optional - uncomment if needed)
# Liveflow.Repo.delete_all(Liveflow.Workflows.NodeContent)
# Liveflow.Repo.delete_all(Liveflow.Workflows.Edge)
# Liveflow.Repo.delete_all(Liveflow.Workflows.Node)
# Liveflow.Repo.delete_all(Liveflow.Workflows.Workflow)

# Create demo workflows
IO.puts("Creating demo workflows...")

workflow1 = Seeds.seed_demo_workflow()
IO.puts("Created: #{workflow1.name}")

workflow2 = Seeds.seed_simple_workflow()
IO.puts("Created: #{workflow2.name}")

IO.puts("Demo data seeding complete!")
