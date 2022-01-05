using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class getscore : MonoBehaviour
{
    private Text scoreText;
    private int score=0;
    // Start is called before the first frame update
    private void Awake()
    {
        scoreText = GetComponent<Text>();
        EventCenter.AddListener(EventDefine.getPoint, UpdateScore);
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener(EventDefine.getPoint, UpdateScore);
    }

    private void UpdateScore()
    {
        score = score + 1;
        scoreText.text = score.ToString();
        if (score == 3)
        {
            EventCenter.Broadcast(EventDefine.win, true);
            EventCenter.Broadcast(EventDefine.IsShowList, false);
        }
    }
}
