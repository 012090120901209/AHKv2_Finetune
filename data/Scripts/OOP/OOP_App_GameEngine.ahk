#Requires AutoHotkey v2.0
#SingleInstance Force
; Real-world OOP Application: Simple Game Engine
; Demonstrates: Entity-component system, game loop, state management

class Vector2D {
    __New(x := 0, y := 0) => (this.x := x, this.y := y)

    Add(other) => Vector2D(this.x + other.x, this.y + other.y)
    Subtract(other) => Vector2D(this.x - other.x, this.y - other.y)
    Multiply(scalar) => Vector2D(this.x * scalar, this.y * scalar)
    Distance(other) => Sqrt((this.x - other.x) ** 2 + (this.y - other.y) ** 2)
    ToString() => Format("({1}, {2})", this.x, this.y)
}

class Component {
    __New(entity) => this.entity := entity
    Update(deltaTime) {
    }  ; Override in subclasses
}

class Transform extends Component {
    __New(entity, x := 0, y := 0) {
        super.__New(entity)
        this.position := Vector2D(x, y)
        this.rotation := 0
        this.scale := Vector2D(1, 1)
    }

    Move(dx, dy) => (this.position := this.position.Add(Vector2D(dx, dy)), this)
    Rotate(degrees) => (this.rotation += degrees, this)
    ToString() => Format("Position: {1}, Rotation: {2}°", this.position.ToString(), this.rotation)
}

class Physics extends Component {
    __New(entity) {
        super.__New(entity)
        this.velocity := Vector2D(0, 0)
        this.acceleration := Vector2D(0, 0)
        this.mass := 1
    }

    ApplyForce(force) => (this.acceleration := this.acceleration.Add(force.Multiply(1 / this.mass)), this)

    Update(deltaTime) {
        this.velocity := this.velocity.Add(this.acceleration.Multiply(deltaTime))
        transform := this.entity.GetComponent("Transform")
        if (transform)
            transform.position := transform.position.Add(this.velocity.Multiply(deltaTime))
        this.acceleration := Vector2D(0, 0)  ; Reset acceleration
    }

    ToString() => Format("Velocity: {1}, Acceleration: {2}", this.velocity.ToString(), this.acceleration.ToString())
}

class Health extends Component {
    __New(entity, maxHealth := 100) {
        super.__New(entity)
        this.maxHealth := maxHealth
        this.currentHealth := maxHealth
    }

    TakeDamage(amount) {
        this.currentHealth := Max(0, this.currentHealth - amount)
        if (this.currentHealth = 0)
            this.entity.Destroy()
        return this
    }

    Heal(amount) => (this.currentHealth := Min(this.maxHealth, this.currentHealth + amount), this)
    IsAlive() => this.currentHealth > 0
    GetHealthPercent() => Round((this.currentHealth / this.maxHealth) * 100)
    ToString() => Format("Health: {1}/{2} ({3}%)", this.currentHealth, this.maxHealth, this.GetHealthPercent())
}

class Entity {
    static nextEntityId := 1

    __New(name) {
        this.entityId := Entity.nextEntityId++
        this.name := name
        this.components := Map()
        this.active := true
        this.tags := []
    }

    AddComponent(componentType, component) => (this.components[componentType] := component, this)
    GetComponent(componentType) => this.components.Has(componentType) ? this.components[componentType] : ""
    HasComponent(componentType) => this.components.Has(componentType)
    AddTag(tag) => (this.tags.Push(tag), this)
    HasTag(tag) {
        for t in this.tags
            if (t = tag)
                return true
        return false
    }

    Update(deltaTime) {
        if (!this.active)
            return

        for type, component in this.components
            component.Update(deltaTime)
    }

    Destroy() => (this.active := false, this)

    ToString() {
        info := Format("[Entity #{1}] {2}{3}`n", this.entityId, this.name, this.active ? "" : " (DESTROYED)")
        for type, component in this.components
            info .= "  " . type . ": " . component.ToString() . "`n"
        return info
    }
}

class GameWorld {
    __New() => (this.entities := [], this.time := 0)

    CreateEntity(name) {
        entity := Entity(name)
        this.entities.Push(entity)
        return entity
    }

    Update(deltaTime) {
        this.time += deltaTime
        for entity in this.entities
            entity.Update(deltaTime)
    }

    FindEntitiesByTag(tag) {
        results := []
        for entity in this.entities
            if (entity.active && entity.HasTag(tag))
                results.Push(entity)
        return results
    }

    FindEntitiesWithComponent(componentType) {
        results := []
        for entity in this.entities
            if (entity.active && entity.HasComponent(componentType))
                results.Push(entity)
        return results
    }

    RemoveDestroyedEntities() {
        i := 1
        while (i <= this.entities.Length) {
            if (!this.entities[i].active)
                this.entities.RemoveAt(i)
            else
                i++
        }
    }

    GetEntityCount() {
        count := 0
        for entity in this.entities
            if (entity.active)
                count++
        return count
    }

    GetWorldStats() {
        stats := "Game World Statistics`n" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "=" . "`n"
        stats .= Format("Game time: {1:.2f}s`n", this.time)
        stats .= Format("Active entities: {1}`n", this.GetEntityCount())
        stats .= Format("Total entities: {1}", this.entities.Length)
        return stats
    }
}

class Game {
    __New(name) {
        this.name := name
        this.world := GameWorld()
        this.running := false
        this.deltaTime := 0.016  ; ~60 FPS
    }

    Start() {
        this.running := true
        MsgBox(this.name . " started!")
    }

    Stop() {
        this.running := false
        MsgBox(this.name . " stopped!")
    }

    Tick() {
        if (!this.running)
            return

        this.world.Update(this.deltaTime)
    }

    RunSimulation(ticks) {
        loop ticks
            this.Tick()
        MsgBox(Format("Ran {1} ticks (sim time: {2:.2f}s)", ticks, ticks * this.deltaTime))
    }
}

; Usage - Create a simple game
game := Game("Space Battle Simulator")

; Create player
player := game.world.CreateEntity("Player")
player.AddTag("player").AddTag("controllable")

playerTransform := Transform(player, 100, 100)
playerPhysics := Physics(player)
playerHealth := Health(player, 100)

player.AddComponent("Transform", playerTransform)
    .AddComponent("Physics", playerPhysics)
    .AddComponent("Health", playerHealth)

; Create enemies
enemy1 := game.world.CreateEntity("Enemy1")
enemy1.AddTag("enemy")
enemy1.AddComponent("Transform", Transform(enemy1, 300, 200))
    .AddComponent("Physics", Physics(enemy1))
    .AddComponent("Health", Health(enemy1, 50))

enemy2 := game.world.CreateEntity("Enemy2")
enemy2.AddTag("enemy")
enemy2.AddComponent("Transform", Transform(enemy2, 400, 150))
    .AddComponent("Physics", Physics(enemy2))
    .AddComponent("Health", Health(enemy2, 50))

; Create power-up
powerup := game.world.CreateEntity("Health Pack")
powerup.AddTag("powerup")
powerup.AddComponent("Transform", Transform(powerup, 250, 250))

MsgBox("Initial state:`n" . player.ToString())

; Start game
game.Start()

; Simulate player movement
playerPhysics.ApplyForce(Vector2D(10, 5))
game.Tick()

MsgBox("After movement:`n" . player.ToString())

; Simulate combat
playerHealth.TakeDamage(30)
enemy1.GetComponent("Health").TakeDamage(40)

MsgBox("After damage:`n" . player.ToString())
MsgBox("Enemy1:`n" . enemy1.ToString())

; Simulate more ticks
game.RunSimulation(10)

; Find entities
enemies := game.world.FindEntitiesByTag("enemy")
MsgBox("Found " . enemies.Length . " enemies")

entitiesWithHealth := game.world.FindEntitiesWithComponent("Health")
MsgBox("Entities with health:`n" . entitiesWithHealth.Map((e) => e.name).Join(", "))

; Destroy an enemy
enemy1.GetComponent("Health").TakeDamage(20)  ; Kill it
game.world.RemoveDestroyedEntities()

MsgBox("After cleanup:`n" . game.world.GetWorldStats())

; Final state
MsgBox("Player final state:`n" . player.ToString())

game.Stop()
