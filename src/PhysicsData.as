/**
 * Created by leandro on 2/20/2016.
 */
package {
public class PhysicsData {
    public var owner:Object;
    public var x:Number = 0;
    public var y:Number = 0;
    public var z:Number = 0;
    public var velX:Number = 0;
    public var velY:Number = 0;
    public var width:Number = 0;
    public var height:Number = 0;
    public var direction:Number = 0;
    public var colliding:PhysicsData = null;
    public var checkCollisions:Boolean = false;
    public var container:Boolean = false;

    public function PhysicsData() {

    }
}
}
