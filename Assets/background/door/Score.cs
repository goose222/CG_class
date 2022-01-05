using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Score : MonoBehaviour
{
    public int score = 0;

    private void OnTriggerEnter(Collider ball)
    {
        score = score + 1;
        Destroy(ball.gameObject, 0.5f);
        EventCenter.Broadcast(EventDefine.getPoint,score);
        //scoretext.text = score.ToString();
    }
}