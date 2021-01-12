using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class getPointsPos : MonoBehaviour
{
    [Header("����X��")]
    public bool m_isLockX = false;
    [Header("����Y��")]
    public bool m_isLockY = false;
    [Header("����Z��")]
    public bool m_isLockZ = true;

    IEnumerator OnMouseDown()
    {
        //����������������ϵת��Ϊ��Ļ����ϵ ����vector3 �ṹ�����ScreenSpace�洢����������ȷ��Ļ����ϵZ���λ��  
        Vector3 ScreenSpace = Camera.main.WorldToScreenPoint(transform.position);
        //������������裬1������������ϵ��2ά�ģ���Ҫת����3ά����������ϵ��2ֻ����ά������²������������λ��������ľ��룬offset���Ǿ���  
        Vector3 offset = transform.position - Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, ScreenSpace.z));

        Debug.Log("down");

        //������������ʱ  
        while (Input.GetMouseButton(0))
        {
            //�õ���������2ά����ϵλ��  
            Vector3 curScreenSpace = new Vector3(Input.mousePosition.x, Input.mousePosition.y, ScreenSpace.z);
            //����ǰ����2άλ��ת������ά��λ�ã��ټ��������ƶ���  
            Vector3 CurPosition = Camera.main.ScreenToWorldPoint(curScreenSpace) + offset;
            //CurPosition��������Ӧ�õ��ƶ���������transform��position���� 
            Vector3 position= CurPosition;
            if (m_isLockX)
                position.x = transform.position.x;
            if (m_isLockY)
                position.y = transform.position.y;
            if (m_isLockZ)
                position.z = transform.position.z;
            //��ס
            transform.position = position;
            //�������Ҫ  
            yield return new WaitForFixedUpdate();
        }


    }
}
