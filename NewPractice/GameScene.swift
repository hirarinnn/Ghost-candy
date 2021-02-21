//
//  GameScene.swift
//  NewPractice
//
//  Created by 諸星水晶 on 2020/12/10.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct Constants {
        static let PlayerImages = ["kyarakuta1", "kyarakuta2", "kyarakuta3", "kyarakuta4"]
    }
    
    
    struct ColliderType {
        
        static let Player: UInt32 = (1 << 0)
       
        static let World: UInt32  = (1 << 1)
        
        static let Coral: UInt32  = (1 << 2)
        
        static let Score: UInt32  = (1 << 3)
        
        static let None: UInt32   = (1 << 4)
    }
    
    
    var baseNode: SKNode!
    var coralNode: SKNode!
    var player: SKSpriteNode!
    var scoreLabelNode: SKLabelNode!
    var score: UInt32!
    //ユーザーランキング
    let Savedata: UserDefaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        self.physicsWorld.contactDelegate = self
        
        score = 0
        
        baseNode = SKNode()
        baseNode.speed = 1.0
        self.addChild(baseNode)
        
        coralNode = SKNode()
        baseNode.addChild(coralNode)
        
        self.setupBackgroundSea()
        
        self.setupBackgroundRock()
        
        self.setupCeilingAndLand()
        
        self.setupPlayer()
        
        self.setupCoral()
        
        self.setupScoreLabel()
    }
    
    func setupScoreLabel() {
        // フォント名"Arial Bold"でラベルを作成
        scoreLabelNode = SKLabelNode(fontNamed: "Arial Bold")
        // フォント色を黄色に設定
        scoreLabelNode.fontColor = UIColor.black
        // 表示位置を設定
        scoreLabelNode.position = CGPoint(x: self.frame.width / 2.0, y: self.frame.size.height * 0.9)
        // 最前面に表示
        scoreLabelNode.zPosition = 100.0
        // スコアを表示
        scoreLabelNode.text = String(score)

        self.addChild(scoreLabelNode)
    }

    
    
    func setupBackgroundSea() {
        
        
        let texture = SKTexture(imageNamed: "background")
        texture.filteringMode = .nearest
        
        let needNumber = 2.0 + (self.frame.size.width / texture.size().width)
        
        let moveAnim = SKAction.moveBy(x: -texture.size().width, y: 0.0,duration: TimeInterval(texture.size().width / 10.0))
        
        let resetAnim = SKAction.moveBy(x: texture.size().width, y: 0.0, duration: 0.0)
        
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([moveAnim,resetAnim]))
        
        var i: CGFloat = 0
        while  i < needNumber {
            let sprite = SKSpriteNode(texture: texture)
            sprite.zPosition = -100.0
            sprite.position = CGPoint(x: i * sprite.size.width, y: self.frame.size.height / 2.0)
            sprite.run(repeatForeverAnim)
            baseNode.addChild(sprite)
            i += 1
        }
    
    }
    
    func setupBackgroundRock() {
        let under = SKTexture(imageNamed: "rock_under")
        under.filteringMode = .nearest
        
        var needNumber = 2.0 + (self.frame.size.width / under.size().width)
        
        let moveUnderAnim = SKAction.moveBy(x: -under.size().width, y: 0.0, duration: TimeInterval(under.size().width / 20.0))
        
        let resetUnderAnim = SKAction.moveBy(x: under.size().width, y: 0.0, duration: 0.0)
        
        let repeatForeverUnderAnim = SKAction.repeatForever(SKAction.sequence([moveUnderAnim,resetUnderAnim]))
        
        var i: CGFloat = 0
        while  i < needNumber {
            let sprite = SKSpriteNode(texture: under)
            sprite.zPosition = -50.0
            sprite.position = CGPoint(x: i * sprite.size.width, y: self.frame.size.height / 8.0)
            sprite.run(repeatForeverUnderAnim)
            baseNode.addChild(sprite)
            i += 1
        }
        
        let above = SKTexture(imageNamed: "rock_above")
        above.filteringMode = .nearest
        
        needNumber = 2.0 + (self.frame.size.width / above.size().width)
        
        let moveAboveAnim = SKAction.moveBy(x: -above.size().width, y: 0.0, duration: TimeInterval(above.size().width / 20.0))
        
        let resetAboveAnim = SKAction.moveBy(x: above.size().width, y: 0.0, duration: 0.0)
        
        let repeatForeverAboveAnim = SKAction.repeatForever(SKAction.sequence([moveAboveAnim,resetAboveAnim]))
        
        var j: CGFloat = 0
        while  j < needNumber {
            let sprite = SKSpriteNode(texture: above)
            sprite.zPosition = -50.0
            sprite.position = CGPoint(x: j * sprite.size.width, y: self.frame.size.height / 1.08)
            sprite.run(repeatForeverAboveAnim)
            baseNode.addChild(sprite)
            j += 1
        }
        
    }
    
    
    
    func setupCeilingAndLand() {
        
        let land = SKTexture(imageNamed: "land")
        land.filteringMode = .nearest
        
        var needNumber = 2.0 + (self.frame.size.width / land.size().width)
        
        let moveLandAnim = SKAction.moveBy(x: -land.size().width, y: 0.0, duration: TimeInterval(land.size().width / 100.0))
        
        let resetLandAnim = SKAction.moveBy(x: land.size().width, y: 0.0, duration: 0.0)
        
        let repeatForeverLandAnim = SKAction.repeatForever(SKAction.sequence([moveLandAnim,resetLandAnim]))
        
        var i: CGFloat = 0
        while  i < needNumber {
            let sprite = SKSpriteNode(texture: land)
            sprite.position = CGPoint(x: i * sprite.size.width, y: self.frame.size.height / 15.0)
            sprite.physicsBody = SKPhysicsBody(texture: land, size: land.size())
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = ColliderType.World
            sprite.run(repeatForeverLandAnim)
            baseNode.addChild(sprite)
            i += 1
        }
        
        let ceiling = SKTexture(imageNamed: "ceiling")
        ceiling.filteringMode = .nearest
        
        needNumber = 2.0 + (self.frame.size.width / ceiling.size().width)
        
        
        var j: CGFloat = 0
        while  j < needNumber {
            let sprite = SKSpriteNode(texture: ceiling)
            sprite.position = CGPoint(x: j * sprite.size.width, y: self.frame.size.height / 1)
            sprite.physicsBody = SKPhysicsBody(texture: ceiling, size: ceiling.size())
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = ColliderType.World
            sprite.run(repeatForeverLandAnim)
            baseNode.addChild(sprite)
            j += 1
        }
        
    }
    
    func setupPlayer() {
        
        var playerTexture = [SKTexture]()
        
       
        for imageName in Constants.PlayerImages {
            let texture = SKTexture(imageNamed: imageName)
            texture.filteringMode = .linear
            playerTexture.append(texture)
        }
        
        
        let playerAnimation = SKAction.animate(with: playerTexture, timePerFrame: 0.2)
        
        let loopAnimation = SKAction.repeatForever(playerAnimation)
        
        
        player = SKSpriteNode(texture: playerTexture[0])
        
        player.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        
        player.run(loopAnimation)
        
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture[0], size: playerTexture[0].size())
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        
        
        player.physicsBody?.categoryBitMask = ColliderType.Player
       
        player.physicsBody?.collisionBitMask = ColliderType.World | ColliderType.Coral
        player.physicsBody?.contactTestBitMask = ColliderType.World | ColliderType.Coral
        
        self.addChild(player)
    }
    
    func setupCoral() {
        let coralUnder = SKTexture(imageNamed: "coral_under")
        coralUnder.filteringMode = .linear
        let coralAbove = SKTexture(imageNamed: "coral_above")
        coralAbove.filteringMode = .linear
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * coralUnder.size().width)
        
        
        let moveAnim = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration:TimeInterval(distanceToMove / 100.0))
        
        let removeAnim = SKAction.removeFromParent()
        
        let coralAnim = SKAction.sequence([moveAnim, removeAnim])
        
        // キャンディを生成するメソッドを呼び出すアニメーションを作成
        let newCoralAnim = SKAction.run({
            // キャンディに関するノードを乗せるノードを作成
            let coral = SKNode()
            coral.position = CGPoint(x: self.frame.size.width + coralUnder.size().width * 2, y: 0.0)
            coral.zPosition = -40.0
            
            // 地面から伸びるキャンディのy座標を算出
            let height = UInt32(self.frame.size.height / 12)
            let y = CGFloat(arc4random_uniform(height * 2) + height)
            
            // 地面から伸びるキャンディを作成
            let under = SKSpriteNode(texture: coralUnder)
            under.position = CGPoint(x: 0.0, y: y)
            
            // キャンディに物理シミュレーションを設定
            under.physicsBody = SKPhysicsBody(texture: coralUnder, size: under.size)
            under.physicsBody?.isDynamic = false
            under.physicsBody?.categoryBitMask = ColliderType.Coral
            under.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(under)
            
            // 天井から伸びるキャンディを作成
            let above = SKSpriteNode(texture: coralAbove)
            above.position = CGPoint(x: 0.0, y: y + (under.size.height / 2.0) + 160.0 + (above.size.height / 2.0))
            
            // キャンディに物理シミュレーションを設定
            above.physicsBody = SKPhysicsBody(texture: coralAbove, size: above.size)
            above.physicsBody?.isDynamic = false
            above.physicsBody?.categoryBitMask = ColliderType.Coral
            above.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(above)
            
            // スコアをカウントアップするノードを作成
            let scoreNode = SKNode()
            scoreNode.position = CGPoint(x: (above.size.width / 2.0) + 5.0, y: self.frame.height / 2.0)
            
            // スコアノードに物理シミュレーションを設定
            scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10.0, height: self.frame.size.height))
            scoreNode.physicsBody?.isDynamic = false
            scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
            scoreNode.physicsBody?.contactTestBitMask = ColliderType.Player
            coral.addChild(scoreNode)
            coral.run(coralAnim)
            
            self.coralNode.addChild(coral)
        })
        // 一定間隔待つアニメーションを作成
        let delayAnim = SKAction.wait(forDuration: 2.5)
        // 上記2つを永遠と繰り返すアニメーションを作成
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([newCoralAnim, delayAnim]))
        // この画面で実行
        self.run(repeatForeverAnim)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 既にゲームオーバー状態の場合
        if baseNode.speed <= 0.0 {
            return
        }
        
        let rawScoreType = ColliderType.Score
        let rawNoneType = ColliderType.None
        
        if (contact.bodyA.categoryBitMask & rawScoreType) == rawScoreType ||
           (contact.bodyB.categoryBitMask & rawScoreType) == rawScoreType {
            // スコアを加算しラベルに反映
            score = score + 1
            scoreLabelNode.text = String(score)
            Savedata.set(score, forKey: "key")
            
            
            
            // スコアラベルをアニメーション
            let scaleUpAnim = SKAction.scale(to: 1.5, duration: 0.1)
            let scaleDownAnim = SKAction.scale(to: 1.0, duration: 0.1)
            scoreLabelNode.run(SKAction.sequence([scaleUpAnim, scaleDownAnim]))
            
            // スコアカウントアップに設定されているcontactTestBitMaskを変更
            if (contact.bodyA.categoryBitMask & rawScoreType) == rawScoreType {
                contact.bodyA.categoryBitMask = ColliderType.None
                contact.bodyA.contactTestBitMask = ColliderType.None
            } else {
                contact.bodyB.categoryBitMask = ColliderType.None
                contact.bodyB.contactTestBitMask = ColliderType.None
            }
        } else if (contact.bodyA.categoryBitMask & rawNoneType) == rawNoneType ||
                  (contact.bodyB.categoryBitMask & rawNoneType) == rawNoneType {
            // なにもしない
        } else {
            // baseNodeに追加されたものすべてのアニメーションを停止
            baseNode.speed = 0.0
            
            // プレイキャラのBitMaskを変更
            player.physicsBody?.collisionBitMask = ColliderType.World
            // プレイキャラに回転アニメーションを実行
            let rolling = SKAction.rotate(byAngle: CGFloat(M_PI) * player.position.y * 0.01, duration: 1.0)
            player.run(rolling, completion:{
                // アニメーション終了時にプレイキャラのアニメーションを停止
                self.player.speed = 0.0
            })
            
            //スコア保存
            let highScore1:UInt32 = UInt32(Savedata.integer(forKey: "score1"))
            let highScore2:UInt32 = UInt32(Savedata.integer(forKey: "score2"))
            let highScore3:UInt32 = UInt32(Savedata.integer(forKey: "score3"))
            
            if score > highScore1 {
                Savedata.setValue(score, forKey: "score1")
                Savedata.setValue(highScore1, forKey: "score2")
                Savedata.setValue(highScore2, forKey: "score3")
            }else if score > highScore2 {
                Savedata.setValue(score, forKey: "score2")
                Savedata.setValue(highScore2, forKey: "score3")
            }else if score > highScore3 {
                Savedata.setValue(score, forKey: "score3")
            }
            
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ゲーム進行中のとき
        if 0.0 < baseNode.speed {
            for touch in touches {
                _ = touch.location(in: self)
                // プレイヤーに加えられている力をゼロにする
                player.physicsBody?.velocity = CGVector.zero
                // プレイヤーにy軸方向へ力を加える
                player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 19.0))
            }
        } else if baseNode.speed == 0.0 && player.speed == 0.0 {
            // ゲームオーバー時はリスタート
            // 障害物を全て取り除く
            coralNode.removeAllChildren()
            
            // スコアをリセット
            score = 0
            scoreLabelNode.text = String(score)
            
            // プレイキャラを再配置
            player.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
            player.physicsBody?.velocity = CGVector.zero
            player.physicsBody?.collisionBitMask = ColliderType.World | ColliderType.Coral
            player.zRotation = 0.0
            
            // アニメーションを開始
            player.speed = 2.0
            baseNode.speed = 1.0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
