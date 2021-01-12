Shader "Custom/goochShading"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Warm_Color("Warm Color",Color) = (0.5,0.5,0.0,1)//ůɫ
        _Cool_Color("Cool Color",Color) = (0,0,0.55,1)//��ɫ
        _Specular_Color("Specular Color",Color) = (1,1,1,1)//�߹�
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

            fixed4 _Surface_Color;//���屾������ɫ
            fixed4 _Warm_Color;
            fixed4 _Cool_Color;
            fixed4 _Specular_Color;

            struct a2v {
                float4 vertex:POSITION;//λ��
                float3 normal:NORMAL;//����
            };
            struct v2f {
                float4 pos:SV_POSITION;//���ÿռ�����
                float3 worldPos:TEXCOORD1;//����1
                float3 worldnormal:TEXCOORD2;//����2
            };

            v2f vert(a2v v) {//������ɫ��
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldnormal = UnityObjectToWorldNormal(v.normal);//��ȡ���߷���
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;//��ȡ��������
                return o;
            }

            fixed4 frag(v2f o) :SV_TARGET{
                float3 LightDir =
                normalize(UnityWorldSpaceLightDir(o.worldPos));//���߷���
                float3 ViewDir =
                normalize(UnityWorldSpaceViewDir(o.worldPos));//��Ұ����
                float t = 0.5 * (dot(o.worldnormal,LightDir) + 1);//���
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
