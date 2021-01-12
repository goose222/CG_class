Shader "Custom/goochShading"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Warm_Color("Warm Color",Color) = (0.5,0.5,0.0,1)//暖色
        _Cool_Color("Cool Color",Color) = (0,0,0.55,1)//冷色
        _Specular_Color("Specular Color",Color) = (1,1,1,1)//高光
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  }
        //LOD 200

        pass {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma multi_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Surface_Color;//物体本来的颜色
            fixed4 _Warm_Color;
            fixed4 _Cool_Color;
            fixed4 _Specular_Color;

            struct a2v {
                float4 vertex:POSITION;//位置
                float3 normal:NORMAL;//法线
            };
            struct v2f {
                float4 pos:SV_POSITION;//剪裁空间坐标
                float3 worldPos:TEXCOORD1;//材质1
                float3 worldnormal:TEXCOORD2;//材质2
            };

            v2f vert(a2v v) {//顶点着色器
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldnormal = UnityObjectToWorldNormal(v.normal);//获取法线方向
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;//获取世界坐标
                return o;
            }

            fixed4 frag(v2f o) :SV_TARGET{
                float3 LightDir =
                normalize(UnityWorldSpaceLightDir(o.worldPos));//光线方向
                float3 ViewDir =
                normalize(UnityWorldSpaceViewDir(o.worldPos));//视野方向
                float t = 0.5 * (dot(o.worldnormal,LightDir) + 1);//点乘
                float3 r =
                2 * dot(o.worldnormal,LightDir) * o.worldnormal - LightDir;//phong
                float s = saturate(100 * dot(r,ViewDir) - 97);

                fixed4 c = s * _Specular_Color + (1 - s) * (t * (_Warm_Color + 0.25 * _Surface_Color) + (1 - t) * (_Cool_Color + 0.25 * _Surface_Color));

                return c;
            }
            ENDCG
        }
    }
        FallBack "Diffuse"
}
