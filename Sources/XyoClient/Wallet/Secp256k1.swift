import BigInt

struct Point {
    let x: BigInt
    let y: BigInt
}

struct Secp256k1CurveConstants {
    static let p = BigInt(
        "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F", radix: 16)!
    static let a = BigInt(0)
    static let b = BigInt(7)
    static let n = BigInt(
        "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16)!
    static let g = Point(
        x: BigInt("79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798", radix: 16)!,
        y: BigInt("483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8", radix: 16)!
    )
}
