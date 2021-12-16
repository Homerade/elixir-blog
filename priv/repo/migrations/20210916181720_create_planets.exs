defmodule Blog.Repo.Migrations.CreatePlanets do
  use Ecto.Migration

  def change do
    create table(:planets) do
      add(:name, :string)
      add(:mass, :float)
      add(:diameter, :float)
      add(:density, :float)
      add(:gravity, :float)
      add(:escapeVelocity, :float)
      add(:rotationPeriod, :float)
      add(:lengthOfDay, :float)
      add(:distanceFromSun, :float)
      add(:perihelion, :float)
      add(:aphelion, :float)
      add(:orbitalPeriod, :float)
      add(:orbitalVelocity, :float)
      add(:orbitalInclination, :float)
      add(:orbitalEccentricity, :float)
      add(:obliquityToOrbit, :float)
      add(:meanTemperature, :float)
      add(:surfacePressure, :float)
      add(:numberOfMoons, :integer)
      add(:hasRingSystem, :boolean)
      add(:hasGlobalMagneticField, :boolean)

      timestamps()
    end
  end
end
