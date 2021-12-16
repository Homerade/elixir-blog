defmodule Blog.Planets.Planet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "planets" do
    field :name, :string
    field :mass, :float
    field :diameter, :float
    field :density, :float
    field :gravity, :float
    field :escapeVelocity, :float
    field :rotationPeriod, :float
    field :lengthOfDay, :float
    field :distanceFromSun, :float
    field :perihelion, :float
    field :aphelion, :float
    field :orbitalPeriod, :float
    field :orbitalVelocity, :float
    field :orbitalInclination, :float
    field :orbitalEccentricity, :float
    field :obliquityToOrbit, :float
    field :meanTemperature, :float
    field :surfacePressure, :float
    field :numberOfMoons, :integer
    field :hasRingSystem, :boolean
    field :hasGlobalMagneticField, :boolean
    timestamps()
  end

  def create_changeset(planet, params) do
    planet
    |> cast(params, [
      :name,
      :mass,
      :diameter,
      :density,
      :gravity,
      :escapeVelocity,
      :rotationPeriod,
      :lengthOfDay,
      :distanceFromSun,
      :perihelion,
      :aphelion,
      :orbitalPeriod,
      :orbitalVelocity,
      :orbitalInclination,
      :orbitalEccentricity,
      :obliquityToOrbit,
      :meanTemperature,
      :surfacePressure,
      :numberOfMoons,
      :hasRingSystem,
      :hasGlobalMagneticField
    ])
  end
end
