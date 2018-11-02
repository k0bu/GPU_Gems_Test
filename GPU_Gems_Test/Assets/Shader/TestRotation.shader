Shader "Custom/TestRotation" {
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Tex("合成テクスチャ1", 2D) = "black" {}
        _RSpeed("拡大縮小速度", Float) = 0
        _ThetaSpeed("回転速度", Float) = 0
    }

    SubShader
    {
        BlendOp Add
        Blend One Zero
        Cull Back
        Lighting Off
        ZWrite On
        ZTest LEqual
        Fog{ Mode Off }

        Tags{ "Queue" = "Geometry" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
        Pass{
        CGPROGRAM

#pragma vertex vert
#pragma fragment frag

            uniform sampler2D _Tex;
            uniform half4 _Tex_ST;
            uniform half3 _Color;
            uniform half _RSpeed;
            uniform half _ThetaSpeed;

            struct vertexInput {
                half4 vertex : POSITION;
                half2 uv : TEXCOORD0;
            };

            struct vertexOutput {
                half4 pos : SV_POSITION;
                half2 uvTex : TEXCOORD0;
            };

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uvTex = input.uv.xy ;//* _Tex_ST.xy ;//+ _Tex_ST.zw;
                return output;
            }

            half2 ConvertPolarCordinate(half2 uv, half rSpeed, half thetaSpeed) {
                const half PI2THETA = 1 / (3.1415926535 * 2);
                half2 res;

                // UV値を極座標系に変換
                uv =  2 * uv - 1;
                half r = 1 - sqrt(uv.x * uv.x + uv.y * uv.y);
                half theta = atan2(uv.y, uv.x) * PI2THETA;// + 0.5; //　0.75はPhotoShopの変換に合わせた、回転の始軸の調整

                // スクロールのための処理
                res.y = r + rSpeed * _Time;
				//r += rSpeed * _Time;
				//res.y = r * sin(theta + thetaSpeed * _Time);
                res.x = theta;// + thetaSpeed * _Time;
				//res.x = r * cos(theta + thetaSpeed * _Time);
				//res = uv;
                return res;
            }

            half3 frag(vertexOutput input) : SV_TARGET
            {
                half2 uv = input.uvTex;
                uv = ConvertPolarCordinate(uv, _RSpeed, _ThetaSpeed);
                return tex2D(_Tex, uv).rgb * _Color;
            }

        ENDCG
        }
    }
}