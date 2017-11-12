# Gollum Wiki with PlantUML

## Warning:

**Hey, this is embedded inside the Docker container.  You probably want to mount an external directory containing a git repository so your wiki contents has a lifespan beyond this particular container.**

## Starting this up
```
docker run -d -p 4567:4567 -v `pwd`:/gollum gollum
```

## UML Markup Editor
[PlantUML](/plantuml/uml/SyfFKj2rKt3CoKnELR1Io4ZDoSa70000)

@startuml
Bob -> Alice : hello
@enduml
