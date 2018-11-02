// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#ifndef EDO_FUR_SHADER_HELPER
#define EDO_FUR_SHADER_HELPER

// 頂点シェーダへの入力構造体
struct vertInput {
	float4 vertex    : SV_POSITION;
	float4 normal    : NORMAL;
	float2 texcoord  : TEXCOORD0;
	float2 texcoord2 : TEXCOORD1;
};

// フラグメントシェーダへの入力構造体
struct v2f {
	float4 position : POSITION;
	float2 uv       : TEXCOORD0;
	float2 uv2      : TEXCOORD1;
};

// テクスチャ
uniform sampler2D _MainTex;
uniform sampler2D _SubTex;
uniform float4 _Gravity;

v2f vert(vertInput v) {

	const float spacing = 0.35;

	v2f o;
	
	float3 forceDirection = float3(0.0,0.0,0.0);
	float4 position = v.vertex;
	
	// Wind
	forceDirection.x = sin(_Time.y + position.x * 0.05) * 0.2;
	forceDirection.y = cos(_Time.y * 0.7 + position.y * 0.04) * 0.2;
	forceDirection.z = sin(_Time.y * 0.7 + position.y * 0.04) * 0.2;
	
	float3 displacement = forceDirection + _Gravity.xyz;
	
	float displacementFactor = pow(FUR_OFFSET, 3.0);
	float4 aNormal = v.normal;
	aNormal.xyz += displacement * displacementFactor;
	
	float4 n = normalize(aNormal) * FUR_OFFSET * spacing;
	float4 wpos = float4(v.vertex.xyz + n.xyz, 1.0);
	o.position = UnityObjectToClipPos(wpos);
	o.uv  = v.texcoord;
	o.uv2 = v.texcoord2 * 10.0;

	return o;
}

float4 frag(v2f i) : COLOR {
	float4 map = tex2D(_SubTex, i.uv2);
	if (map.a <= 0.0 || map.b < FUR_OFFSET) {
		discard;
	}

	float4 color = tex2D(_MainTex, i.uv);
	color.a = 1.1 - FUR_OFFSET;
	return color;
}

#endif