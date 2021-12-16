defmodule BlogWeb.Api.PlanetView do
  use BlogWeb, :view

  def render("index.json", %{planets: planets}) do
    render_many(planets, __MODULE__, "show.json")
  end

  def render("show.json", %{planet: planet}) do
    %{
      id: planet.id,
      name: planet.name,
      mass: planet.mass,
      diameter: planet.diameter,
      density: planet.density,
      gravity: planet.gravity,
      escapeVelocity: planet.escapeVelocity,
      rotationPeriod: planet.rotationPeriod,
      lengthOfDay: planet.lengthOfDay,
      distanceFromSun: planet.distanceFromSun,
      perihelion: planet.perihelion,
      aphelion: planet.aphelion,
      orbitalPeriod: planet.orbitalPeriod,
      orbitalVelocity: planet.orbitalVelocity,
      orbitalInclination: planet.orbitalInclination,
      orbitalEccentricity: planet.orbitalEccentricity,
      obliquityToOrbit: planet.obliquityToOrbit,
      meanTemperature: planet.meanTemperature,
      surfacePressure: planet.surfacePressure,
      numberOfMoons: planet.numberOfMoons,
      hasRingSystem: planet.hasRingSystem,
      hasGlobalMagneticField: planet.hasGlobalMagneticField
    }
  end
end
