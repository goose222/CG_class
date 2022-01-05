using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Loading : MonoBehaviour
{
    public string SceneName;
    private Text txt_Progress;
    private AsyncOperation ao;
    private bool isLoad=false;

    private void Awake()
    {
        txt_Progress = GetComponent<Text>();
        EventCenter.AddListener(EventDefine.StartLoadScene, StartLoad);
        gameObject.SetActive(false);
    }
    private void OnDestroy()
    {
        EventCenter.RemoveListener(EventDefine.StartLoadScene, StartLoad);
    }
    private void StartLoad()
    {
        gameObject.SetActive(true);
        StartCoroutine("Load");
    }
    IEnumerator Load() 
    {
        int displayProgress = -1;
        int toProgress = 100;
        while (displayProgress< toProgress) 
        {
            ++displayProgress;
            ShowProgress(displayProgress);
            if (isLoad == false) 
            {
                ao = SceneManager.LoadSceneAsync("game");
                ao.allowSceneActivation = false;
                isLoad = true;
            }
            
            if (displayProgress == 100) 
            {
                ao.allowSceneActivation = true;
                StopCoroutine("Load");
            }
            yield return new WaitForEndOfFrame();
        }
        
    }
    private void ShowProgress(int progress) 
    {
        txt_Progress.text = progress.ToString()+"%";
    } 
}
