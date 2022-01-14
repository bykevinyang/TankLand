class PalTest1: Tank {

    override func computePreActions() {

        guard energy > 10000 else {return}

        addPreAction(preAction: RadarAction(radius: 5))

        addPreAction(preAction: ShieldAction(energy: 500))

        addPreAction(preAction: SendMessageAction(id: "1612", message: "Hello buddy!"))

 

    }

    override func computePostActions() {

        guard energy > 10000 else {return}

        addPostAction(postAction: MoveAction(distance: 1, direction: .West))

        addPostAction(postAction: MineAction(power: 500, isRover: true, dropDirection: nil, moveDirection: nil))

        addPostAction(postAction: MissileAction(energy: 1000, position: Position(Int.random(in: 0...14), Int.random(in: 0...14))))

        if let rr = self.radarResults {

            print(rr)

        }

    }

}

 

class PalTest2: Tank {

    override func computePreActions() {

        addPreAction(preAction: ReceiveMessageAction(key: "1612"))

    }

    override func computePostActions() {

        //this tank just prints any messages it receives from its pre actions :)

        if let r = self.receivedMessage {

            print(r)

        }

    }

}