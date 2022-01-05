Shader "Custom/Blinn-Phong"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white" {}      // 纹理图片，默认为全白
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8.0,256)) = 20

    }
        SubShader
        {

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"
                #include "Lighting.cginc"
                #include "AutoLight.cginc"
                sampler2D _MainTex;
                float4 _MainTex_ST;     // S:scale, T:translation, _MainTex_ST.xy:缩放值, _MainTex_ST.zw:偏移值
                float _Gloss;
                float4 _Color;
                float4 _Specular;

                struct a2v {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float4 texcoord : TEXCOORD0;            // 第一组纹理
                };
                struct v2f {
                    float4 pos : SV_POSITION;
                    float3 worldNormal : TEXCOORD0;
                    float3 worldPos : TEXCOORD1;
                    float2 uv : TEXCOORD2;                  // 存储纹理坐标
                };
                v2f vert(a2v v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.worldNormal = UnityObjectToWorldNormal(v.normal);
                    o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                    o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                    // 变换纹理，先缩放（乘xy），后偏移（加zw）。下同，下面是内置函数。
                    // o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                    return o;
                }
                fixed4 frag(v2f i) : SV_TARGET {
                    fixed3 worldNormal = normalize(i.worldNormal);
                    fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                    // CG的tex2D函数对纹理进行采样，乘于颜色，作为散射值。
                    fixed3 albedo = tex2D(_MainTex, i.uv).rgb * (_Color.rgb);
                    // 散射值和环境光相乘得到环境光部分
                    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                    // 漫反射公式（Lambert法则）
                    fixed3 diffuse = _LightColor0.rbg * albedo * max(0,dot(worldNormal,worldLightDir));
                    // 下面是高光反射
                    fixed3 viewDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                    fixed3 halfDir = normalize(worldLightDir + viewDir);
                    fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal,halfDir)),_Gloss);
                    return fixed4(ambient + diffuse + specular,1.0);
                }
                ENDCG
            }
        }
        Fallback "Specular"
}